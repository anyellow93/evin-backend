class User < ApplicationRecord
  has_secure_password
  has_many :sesions, foreign_key: :user_id
  has_one :alumno, dependent: :destroy

  ROLES = %w[alumno profesor tecnico padre].freeze

  validates :email,  presence: true, uniqueness: true,
                     format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :nombre, presence: true
  validates :rol,    inclusion: { in: ROLES }

  def alumno?   = rol == 'alumno'
  def profesor? = rol == 'profesor'
  def tecnico?  = rol == 'tecnico'
  def padre?    = rol == 'padre'
end
