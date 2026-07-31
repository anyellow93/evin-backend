module Api::V1
  class AuthController < ApplicationController
    # POST /api/v1/login
    def login
      user = User.find_by(email: params[:email]&.downcase)
      if user&.authenticate(params[:password])
        render json: user_response(user), status: :ok
      else
        render json: { error: "Email o contraseña incorrectos" }, status: :unauthorized
      end
    end

    # POST /api/v1/register
    def register
      user = User.new(
        nombre:   params[:nombre],
        email:    params[:email]&.downcase,
        password: params[:password],
        rol:      params[:rol] || params[:role] || "profesor"
      )
      if user.save
        if user.rol == "alumno"
          alumno = ::Alumno.find_or_initialize_by(nombre: user.nombre)
          alumno.user_id    ||= user.id
          alumno.curso      ||= params[:curso] || ""
          alumno.progreso   ||= 0
          alumno.dificultad ||= "Fácil"
          alumno.save!
        end
        render json: user_response(user), status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # GET /api/v1/me
    def me
      user = usuario_autenticado
      return unless user
      render json: { user: user_data(user) }
    end

    # PATCH /api/v1/me
    def update_me
      user = usuario_autenticado
      return unless user

      # Campos básicos
      attrs = {}
      attrs[:nombre] = params[:nombre].strip if params[:nombre].present?
      attrs[:email]  = params[:email].downcase.strip if params[:email].present?

      # Cambio de contraseña (opcional)
      if params[:password].present?
        unless user.authenticate(params[:password_actual].to_s)
          return render json: { error: "La contraseña actual no es correcta" }, status: :unprocessable_entity
        end
        attrs[:password] = params[:password]
      end

      if user.update(attrs)
        render json: user_response(user), status: :ok
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # POST /api/v1/password/forgot
    def forgot_password
      user = User.find_by(email: params[:email]&.downcase)
      # Respuesta genérica por seguridad — no revelamos si el email existe
      render json: { message: "Si ese correo está registrado, recibirás un enlace en breve." }, status: :ok
    end

    private

    # Helper compartido: decodifica el JWT y devuelve el usuario
    def usuario_autenticado
      token = request.headers["Authorization"]&.split(" ")&.last
      unless token
        render json: { error: "Token no proporcionado" }, status: :unauthorized
        return nil
      end
      begin
        payload = JWT.decode(token, jwt_secret, true, algorithm: "HS256").first
        User.find(payload["user_id"])
      rescue JWT::DecodeError, ActiveRecord::RecordNotFound
        render json: { error: "Token inválido" }, status: :unauthorized
        nil
      end
    end

    def user_response(user)
      { token: generar_jwt(user), user: user_data(user) }
    end

    def generar_jwt(user)
      payload = {
        user_id: user.id,
        email:   user.email,
        rol:     user.rol,
        exp:     24.hours.from_now.to_i
      }
      JWT.encode(payload, jwt_secret, "HS256")
    end

    def user_data(user)
      {
        id:     user.id,
        nombre: user.nombre,
        email:  user.email,
        rol:    user.rol,
        alumno_id: user.alumno&.id
      }
    end

    def jwt_secret
      Rails.application.secret_key_base
    end
  end
end
