class User < ApplicationRecord
  has_secure_password

  has_many :sesions, foreign_key: :user_id
  has_one :alumno, dependent: :destroy

  ROLES = %w[alumno profesor tecnico padre].freeze

  validates :email, presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :nombre, presence: true
  validates :role, inclusion: { in: ROLES }

  def alumno?    = role == 'alumno'
  def profesor?  = role == 'profesor'
  def tecnico?   = role == 'tecnico'
  def padre?     = role == 'padre'
end
