class Sesion < ApplicationRecord
  belongs_to :juego, optional: true

  validates :alumno_nombre, presence: true
  validates :juego_nombre,  presence: true
  validates :aciertos, presence: true,
                       numericality: { only_integer: true,
                                       greater_than_or_equal_to: 0 }
  validates :intentos, presence: true,
                       numericality: { only_integer: true,
                                       greater_than: 0 }

  validate :aciertos_no_superan_intentos

  before_validation :establecer_fecha

  scope :recientes,  -> { order(fecha: :desc) }
  scope :de_alumno,  ->(nombre) { where("alumno_nombre ILIKE ?", "%#{nombre}%") }
  scope :de_juego,   ->(nombre) { where("juego_nombre ILIKE ?",  "%#{nombre}%") }
  scope :ultimo_mes, -> { where(fecha: 1.month.ago..) }

  def porcentaje_aciertos
    return 0 if intentos.to_i.zero?
    ((aciertos.to_f / intentos) * 100).round
  end

  def as_json(options = {})
    super(options.merge(only: %i[id alumno_nombre juego_nombre fecha aciertos intentos alumno_id juego_id]))
      .merge("porcentaje" => porcentaje_aciertos)
  end

  private

  def aciertos_no_superan_intentos
    return unless aciertos && intentos
    return unless aciertos > intentos
    errors.add(:aciertos, "no pueden superar el número de intentos")
  end

  def establecer_fecha
    self.fecha ||= Date.today
  end
end
