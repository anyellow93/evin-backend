module Api
  module V1
    class AlumnosController < ApplicationController
      before_action :authenticate_user!
      before_action :autorizar_gestion!, only: [ :create, :update, :destroy ]
      before_action :set_alumno,         only: [ :show, :update, :destroy, :estadisticas ]
      before_action :autorizar_lectura!, only: [ :show, :estadisticas ]

      # GET /api/v1/alumnos
      def index
        if current_user.profesor? || current_user.tecnico?
          alumnos = Alumno.all.order(:nombre)
          render json: alumnos
        elsif current_user.alumno? || current_user.padre?
          # Un alumno o padre solo puede ver su propio registro, nunca el listado completo
          render json: [ current_user.alumno ].compact
        else
          render json: { error: "No autorizado" }, status: :forbidden
        end
      end

      # GET /api/v1/alumnos/:id
      def show
        render json: @alumno
      end

      # GET /api/v1/alumnos/:id/estadisticas
      def estadisticas
        sesiones = Sesion.where(alumno_id: @alumno.id).order(created_at: :desc)

        # Sesiones totales
        sesiones_totales = sesiones.count

        # Última sesión
        ultima_sesion = sesiones.first&.fecha

        # Juegos practicados y favorito
        juegos_count = Sesion.where(alumno_id: @alumno.id).group(:juego).count
        juego_favorito = juegos_count.max_by { |_, v| v }&.first
        juegos_practicados = juegos_count.keys

        # Racha de días consecutivos activos
        dias_con_sesion = sesiones
          .pluck(:fecha)
          .compact
          .map { |f| f.to_date rescue nil }
          .compact
          .uniq
          .sort
          .reverse

        racha = 0
        if dias_con_sesion.any?
          racha = 1
          dias_con_sesion.each_cons(2) do |dia_actual, dia_anterior|
            if (dia_actual - dia_anterior).to_i == 1
              racha += 1
            else
              break
            end
          end
        end

        # Tendencia de mejora — comparar primera mitad vs segunda mitad de sesiones
        tendencia = "sin_datos"
        if sesiones_totales >= 4
          mitad    = sesiones_totales / 2
          recientes = sesiones.first(mitad)
          antiguas  = sesiones.last(mitad)

          media_reciente = recientes.sum { |s| s.intentos > 0 ? s.aciertos.to_f / s.intentos : 0 } / mitad
          media_antigua  = antiguas.sum  { |s| s.intentos > 0 ? s.aciertos.to_f / s.intentos : 0 } / mitad

          diferencia = media_reciente - media_antigua
          tendencia = if diferencia > 0.05
            "mejorando"
          elsif diferencia < -0.05
            "empeorando"
          else
            "estable"
          end
        end

        # Sesiones esta semana
        inicio_semana = Date.today.beginning_of_week
        sesiones_semana = sesiones.where("fecha >= ?", inicio_semana).count

        render json: {
          sesiones_totales:    sesiones_totales,
          sesiones_semana:     sesiones_semana,
          ultima_sesion:       ultima_sesion,
          juegos_practicados:  juegos_practicados,
          juego_favorito:      juego_favorito,
          racha_dias:          racha,
          tendencia:           tendencia
        }
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
        if @alumno.user.present?
          @alumno.user.destroy
        else
          @alumno.destroy
        end
        render json: { message: "Alumno y cuenta eliminados correctamente" }, status: :ok
      end

      private

      def set_alumno
        @alumno = Alumno.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Alumno no encontrado" }, status: :not_found
      end

      def alumno_params
        params.permit(:nombre, :edad, :curso, :dificultad, :progreso)
      end

      def autorizar_gestion!
        unless current_user&.profesor? || current_user&.tecnico?
          render json: { error: "No autorizado. Solo profesores y técnicos pueden gestionar alumnos." },
                 status: :forbidden
        end
      end

      # Restringe show/estadisticas: profesores y técnicos ven cualquier alumno;
      # un alumno o padre solo puede ver su propio registro.
      def autorizar_lectura!
        return if @alumno.nil? # set_alumno ya habrá respondido 404 en ese caso
        return if current_user.profesor? || current_user.tecnico?
        return if @alumno.user_id.present? && @alumno.user_id == current_user.id

        render json: { error: "No autorizado para ver este alumno" }, status: :forbidden
      end
    end
  end
end
