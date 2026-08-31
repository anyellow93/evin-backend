module Api
  module V1
    # Gestión de usuarios y roles. Solo accesible por administradores
    # (usuarios con rol "tecnico"), que es el rol que EVIN usa como
    # administración de la plataforma (ver db/seeds.rb, "Admin EVIN").
    #
    # Esto es lo único que permite que una cuenta obtenga el rol
    # "profesor" o "tecnico": el registro público (auth#register)
    # nunca los admite.
    class UsersController < ApplicationController
      before_action :authenticate_user!
      before_action :autorizar_admin!
      before_action :set_user, only: [ :update ]

      ROLES_ASIGNABLES = User::ROLES

      # GET /api/v1/users
      def index
        render json: User.order(:nombre).map { |u| user_json(u) }
      end

      # PATCH /api/v1/users/:id
      # body: { rol: "profesor" }
      def update
        rol_nuevo = params[:rol] || params[:role]

        unless ROLES_ASIGNABLES.include?(rol_nuevo)
          return render json: { error: "Rol no válido. Roles permitidos: #{ROLES_ASIGNABLES.join(', ')}" },
                        status: :unprocessable_entity
        end

        if @user.id == current_user.id && rol_nuevo != "tecnico"
          return render json: { error: "No puedes quitarte a ti mismo el rol de administrador." },
                        status: :unprocessable_entity
        end

        if @user.update(rol: rol_nuevo)
          render json: user_json(@user)
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_user
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Usuario no encontrado" }, status: :not_found
      end

      def autorizar_admin!
        unless current_user&.tecnico?
          render json: { error: "No autorizado. Solo un administrador puede gestionar usuarios y roles." },
                 status: :forbidden
        end
      end

      def user_json(u)
        { id: u.id, nombre: u.nombre, email: u.email, rol: u.rol }
      end
    end
  end
end
