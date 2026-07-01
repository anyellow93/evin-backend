module Api
  module V1
    class SesionesController < ApplicationController
      before_action :authenticate_user!

      # GET /api/v1/sesiones
      def index
        sesiones = ::Sesion.recientes

        if params[:alumno_id].present?
          sesiones = sesiones.where(alumno_id: params[:alumno_id])
        elsif params[:alumno].present?
          sesiones = sesiones.de_alumno(params[:alumno])
        end

        sesiones = sesiones.de_juego(params[:juego]) if params[:juego].present?

        render json: sesiones
      end

      # POST /api/v1/sesiones
      def create
    sesion = ::Sesion.new(
      alumno:   params[:alumno],
      juego:    params[:juego],
      aciertos: params[:aciertos],
      intentos: params[:intentos],
      fecha:    params[:fecha]
    )

    # Vincular alumno_id si viene y es válido
    if params[:alumno_id].present?
      sesion.alumno_id = params[:alumno_id].to_i
    elsif params[:alumno].present?
      alumno = ::Alumno.find_by(nombre: params[:alumno])
      sesion.alumno_id = alumno.id if alumno
    end

    if sesion.save
      render json: sesion, status: :created
    else
      render json: { errors: sesion.errors.full_messages }, status: :unprocessable_entity
    end
  end

      private

      def sesion_params
        params.permit(:alumno, :alumno_id, :juego, :aciertos, :intentos, :fecha)
      end
    end
  end
end
