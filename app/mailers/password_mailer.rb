class PasswordMailer < ApplicationMailer
  default from: 'EVIN <noreply@evin.click>'

  def reset_password(user)
    @user  = user
    @url   = "https://evin.click/?reset_token=#{user.reset_password_token}"
    mail(to: @user.email, subject: 'Recuperación de contraseña — EVIN')
  end
end
