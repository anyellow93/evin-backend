module Api::V1
  class AuthController < ApplicationController

    # POST /api/v1/login
    def login
      user = User.find_by(email: params[:email]&.downcase)

      if user&.authenticate(params[:password])
        render json: user_response(user), status: :ok
      else
        render json: { error: 'Email o contraseña incorrectos' }, status: :unauthorized
      end
    end

    # POST /api/v1/register
    def register
      user = User.new(
        nombre:   params[:nombre],
        email:    params[:email]&.downcase,
        password: params[:password],
        role:     params[:role] || params[:rol] || 'profesor'
      )

      if user.save
        # Si el rol es alumno, vincular o crear su ficha en la tabla alumnos
        if user.role == 'alumno'
          alumno = ::Alumno.find_or_initialize_by(nombre: user.nombre)
          alumno.user_id    ||= user.id
          alumno.curso      ||= params[:curso] || ''
          alumno.progreso   ||= 0
          alumno.dificultad ||= 'Fácil'
          alumno.save!
        end

        render json: user_response(user), status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # GET /api/v1/me
    def me
      token = request.headers['Authorization']&.split(' ')&.last
      return render json: { error: 'Token no proporcionado' }, status: :unauthorized unless token

      begin
        payload = JWT.decode(token, jwt_secret, true, algorithm: 'HS256').first
        user    = User.find(payload['user_id'])
        render json: { user: user_data(user) }
      rescue JWT::DecodeError, ActiveRecord::RecordNotFound
        render json: { error: 'Token inválido' }, status: :unauthorized
      end
    end

    private

    def user_response(user)
      token = generar_jwt(user)
      {
        token: token,
        user:  user_data(user)
      }
    end

    def generar_jwt(user)
      payload = {
        user_id: user.id,
        email:   user.email,
        role:    user.role,
        exp:     24.hours.from_now.to_i
      }
      JWT.encode(payload, jwt_secret, 'HS256')
    end

    def user_data(user)
      {
        id:     user.id,
        nombre: user.nombre,
        email:  user.email,
        role:   user.role
      }
    end

    def jwt_secret
      Rails.application.secret_key_base
    end
  end
end
