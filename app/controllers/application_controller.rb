class ApplicationController < ActionController::API
  def authenticate_user!
    token = request.headers["Authorization"]&.split(" ")&.last
    unless token
      render json: { error: "Token no proporcionado" }, status: :unauthorized and return
    end
    begin
      payload = JWT.decode(token, jwt_secret, true, algorithm: "HS256").first
      @current_user = User.find(payload["user_id"])
    rescue JWT::ExpiredSignature
      render json: { error: "Token expirado" }, status: :unauthorized
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      render json: { error: "Token inválido" }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end

  private

  def jwt_secret
    Rails.application.secret_key_base
  end
end
