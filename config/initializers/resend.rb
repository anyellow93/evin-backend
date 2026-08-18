require 'net/http'
require 'json'

# Configuración de Action Mailer con Resend via SMTP
Rails.application.config.action_mailer.delivery_method = :smtp
Rails.application.config.action_mailer.smtp_settings = {
  address:              'smtp.resend.com',
  port:                 465,
  user_name:            'resend',
  password:             ENV['RESEND_API_KEY'],
  authentication:       'plain',
  enable_starttls_auto: false,
  ssl:                  true
}
Rails.application.config.action_mailer.default_url_options = { host: 'evin.click', protocol: 'https' }
