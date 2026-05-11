module Api
  module V1
    class JuegosController < ApplicationController
      # GET /api/v1/juegos
      # La lista de juegos es pública — no requiere login
      def index
        juegos = Juego.all.order(:nombre)
        render json: juegos
      end
    end
  end
end
