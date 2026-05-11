module Api
  module V1
    class AlumnosController < ApplicationController
      before_action :authenticate_user!
      before_action :autorizar_gestion!, only: [:create, :update, :destroy]
      before_action :set_alumno,         only: [:show, :update, :destroy]

      # GET /api/v1/alumnos
      def index
        alumnos = Alumno.all.order(:nombre)
        render json: alumnos
      end

      # GET /api/v1/alumnos/:id
      def show
        render json: @alumno
      end

      # POST /api/v1/alumnos
      def create
        alumno = Alumno.new(alumno_params)

        if alumno.save
          render json: alumno, status: :created
        else
          render json: { errors: alumno.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH /api/v1/alumnos/:id
      def update
        if @alumno.update(alumno_params)
          render json: @alumno
        else
          render json: { errors: @alumno.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/alumnos/:id
      def destroy
        # Si el alumno tiene cuenta de usuario asociada, eliminarla también
        # has_one :alumno, dependent: :destroy en User se encarga del alumno
        # pero aquí eliminamos desde el alumno hacia el user
        if @alumno.user.present?
          @alumno.user.destroy  # esto también destruye el alumno por dependent: :destroy
        else
          @alumno.destroy
        end
        render json: { message: 'Alumno y cuenta eliminados correctamente' }, status: :ok
      end

      private

      def set_alumno
        @alumno = Alumno.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Alumno no encontrado' }, status: :not_found
      end

      def alumno_params
        params.permit(:nombre, :edad, :curso, :dificultad, :progreso)
      end

      def autorizar_gestion!
        unless current_user&.profesor? || current_user&.tecnico?
          render json: { error: 'No autorizado. Solo profesores y técnicos pueden gestionar alumnos.' },
                 status: :forbidden
        end
      end
    end
  end
end
