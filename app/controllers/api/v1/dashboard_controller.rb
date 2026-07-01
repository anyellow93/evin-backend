module Api
  module V1
    class DashboardController < ApplicationController
      before_action :authenticate_user!

      # GET /api/v1/dashboard
      def index
        alumnos  = Alumno.all
        sesiones = Sesion.all.order(created_at: :desc)

        hoy          = Date.today
        inicio_semana = hoy.beginning_of_week

        # ── Stats globales ─────────────────────────────────────────
        total_alumnos   = alumnos.count
        total_sesiones  = sesiones.count
        sesiones_hoy    = sesiones.where('fecha = ?', hoy).count
        sesiones_semana = sesiones.where('fecha >= ?', inicio_semana).count

        # ── Alumnos más activos esta semana ────────────────────────
        activos_semana = Sesion
          .where('fecha >= ?', inicio_semana)
          .group(:alumno_id)
          .count
          .sort_by { |_, v| -v }
          .first(5)
          .map do |alumno_id, count|
            alumno = alumnos.find { |a| a.id == alumno_id }
            next unless alumno
            { id: alumno_id, nombre: alumno.nombre, sesiones: count }
          end
          .compact

        # ── Alumnos sin sesiones recientes (más de 7 días) ─────────
        alumno_ids_activos = sesiones
          .where('fecha >= ?', 7.days.ago.to_date)
          .pluck(:alumno_id)
          .uniq

        sin_sesiones = alumnos
          .reject { |a| alumno_ids_activos.include?(a.id) }
          .map { |a| { id: a.id, nombre: a.nombre, curso: a.curso } }
          .first(5)

        # ── Juegos más practicados ─────────────────────────────────
        juegos_populares = Sesion.all
          .group(:juego)
          .count
          .sort_by { |_, v| -v }
          .first(6)
          .map { |juego, count| { juego: juego, sesiones: count } }

        # ── Actividad reciente ─────────────────────────────────────
        actividad_reciente = sesiones.first(10).map do |s|
          {
            id:      s.id,
            alumno:  s.alumno,
            juego:   s.juego,
            fecha:   s.fecha,
            aciertos: s.aciertos,
            intentos: s.intentos
          }
        end

        # ── Tendencias globales ────────────────────────────────────
        mejorando  = 0
        empeorando = 0
        estable    = 0

        alumnos.each do |alumno|
          ses = Sesion.where(alumno_id: alumno.id).order(created_at: :desc)
          next if ses.count < 4

          mitad   = ses.count / 2
          rec     = ses.first(mitad)
          ant     = ses.last(mitad)
          m_rec   = rec.sum { |s| s.intentos > 0 ? s.aciertos.to_f / s.intentos : 0 } / mitad
          m_ant   = ant.sum { |s| s.intentos > 0 ? s.aciertos.to_f / s.intentos : 0 } / mitad
          diff    = m_rec - m_ant

          if diff > 0.05
            mejorando += 1
          elsif diff < -0.05
            empeorando += 1
          else
            estable += 1
          end
        end

        render json: {
          total_alumnos:      total_alumnos,
          total_sesiones:     total_sesiones,
          sesiones_hoy:       sesiones_hoy,
          sesiones_semana:    sesiones_semana,
          activos_semana:     activos_semana,
          sin_sesiones:       sin_sesiones,
          juegos_populares:   juegos_populares,
          actividad_reciente: actividad_reciente,
          tendencias: {
            mejorando:  mejorando,
            empeorando: empeorando,
            estable:    estable
          }
        }
      end
    end
  end
end
