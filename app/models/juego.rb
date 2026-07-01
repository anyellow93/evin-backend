class Juego < ApplicationRecord
  NIVELES = %w[Fácil Medio Difícil].freeze
  TIPOS   = [ "Atención visual", "Memoria visual", "Reconocimiento emocional",
             "Percepción espacial", "Rasgos críticos" ].freeze

  validates :nombre,      presence: true, uniqueness: true
  validates :descripcion, presence: true
  validates :nivel,       inclusion: { in: NIVELES }, allow_nil: true
  validates :tipo,        inclusion: { in: TIPOS },   allow_nil: true
end
