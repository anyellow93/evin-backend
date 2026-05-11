class Alumno < ApplicationRecord
  belongs_to :user, optional: true
  has_many :sesions, dependent: :nullify

  DIFICULTADES = %w[Fácil Medio Difícil].freeze

  validates :nombre,     presence: true
  validates :edad,       numericality: { only_integer: true,
                                         greater_than: 0,
                                         less_than: 100 },
                         allow_nil: true
  validates :dificultad, inclusion: { in: DIFICULTADES,
                                      message: 'debe ser Fácil, Medio o Difícil' },
                         allow_nil: true
  validates :progreso,   numericality: { only_integer: true,
                                         greater_than_or_equal_to: 0,
                                         less_than_or_equal_to: 100 },
                         allow_nil: true

  def as_json(options = {})
    super(options).merge('img' => img_corporativa)
  end

  private

  # Devuelve la imagen corporativa EVIN si el alumno no tiene foto propia
  def img_corporativa
    'img/corporativo.png'
  end
end
