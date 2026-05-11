# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb
# Ejecutar con: rails db:seed
# Para resetear: rails db:schema:load && rails db:seed

puts '🌱 Sembrando base de datos EVIN...'

# ─── JUEGOS ──────────────────────────────────────────────────────────────────

juegos_data = [
  {
    nombre:      'Encuentra las parejas',
    descripcion: 'Ejercicio de memoria visual en el que el alumno debe localizar y emparejar cartas con símbolos iguales. Entrena la atención visual, la fijación y la memoria a corto plazo.',
    img:         'img/juegos/memoria.png',
    nivel:       'Fácil',
    tipo:        'Memoria visual'
  },
  {
    nombre:      'Recuerda las casillas',
    descripcion: 'El alumno observa un patrón de casillas iluminadas y debe reproducirlo de memoria. Trabaja la atención visual sostenida y la memoria espacial.',
    img:         'img/juegos/grid.png',
    nivel:       'Medio',
    tipo:        'Atención visual'
  },
  {
    nombre:      'Radar visual',
    descripcion: 'El alumno debe localizar un estímulo objetivo entre una cuadrícula de imágenes distractoras. Entrena los recorridos visuales y la discriminación figura-fondo.',
    img:         'img/juegos/radar.png',
    nivel:       'Difícil',
    tipo:        'Atención visual'
  }
]

juegos_data.each do |datos|
  Juego.find_or_create_by!(nombre: datos[:nombre]) do |j|
    j.descripcion = datos[:descripcion]
    j.img         = datos[:img]
    j.nivel       = datos[:nivel]
    j.tipo        = datos[:tipo]
  end
end

puts "  ✓ #{Juego.count} juegos creados"

# ─── USUARIOS ────────────────────────────────────────────────────────────────

usuarios_data = [
  { nombre: 'Admin EVIN',      email: 'admin@evin.es',    password: 'evin1234', role: 'tecnico'    },
  { nombre: 'Profesora García', email: 'garcia@evin.es',  password: 'evin1234', role: 'profesor' },
  { nombre: 'Técnico López',   email: 'lopez@evin.es',    password: 'evin1234', role: 'tecnico'  },
  { nombre: 'Familia Martín',  email: 'martin@evin.es',   password: 'evin1234', role: 'padre' }
]

usuarios_data.each do |datos|
  User.find_or_create_by!(email: datos[:email]) do |u|
    u.nombre   = datos[:nombre]
    u.password = datos[:password]
    u.role     = datos[:role]
  end
end

puts "  ✓ #{User.count} usuarios creados"

# ─── ALUMNOS ─────────────────────────────────────────────────────────────────

alumnos_data = [
  { nombre: 'Ana García Ruiz',     edad: 7,  dificultad: 'Fácil',  curso: '1º Primaria', progreso: 40 },
  { nombre: 'Carlos López Sanz',   edad: 9,  dificultad: 'Medio',  curso: '3º Primaria', progreso: 65 },
  { nombre: 'María Sánchez Pérez', edad: 8,  dificultad: 'Fácil',  curso: '2º Primaria', progreso: 55 },
  { nombre: 'Pablo Martín Gil',    edad: 11, dificultad: 'Difícil', curso: '5º Primaria', progreso: 80 },
  { nombre: 'Lucía Torres Vega',   edad: 6,  dificultad: 'Fácil',  curso: '1º Primaria', progreso: 25 },
  { nombre: 'Diego Fernández',     edad: 10, dificultad: 'Medio',  curso: '4º Primaria', progreso: 70 }
]

alumnos_data.each do |datos|
  Alumno.find_or_create_by!(nombre: datos[:nombre]) do |a|
    a.edad       = datos[:edad]
    a.dificultad = datos[:dificultad]
    a.curso      = datos[:curso]
    a.progreso   = datos[:progreso]
  end
end

puts "  ✓ #{Alumno.count} alumnos creados"

# ─── SESIONES DE EJEMPLO ─────────────────────────────────────────────────────

juego_memoria = Juego.find_by(nombre: 'Encuentra las parejas')
juego_grid    = Juego.find_by(nombre: 'Recuerda las casillas')
juego_radar   = Juego.find_by(nombre: 'Radar visual')

sesiones_data = [
  # Ana — nivel fácil, progresando
  { alumno: 'Ana García Ruiz',     juego: juego_memoria.nombre, aciertos: 6,  intentos: 10, fecha: 10.days.ago },
  { alumno: 'Ana García Ruiz',     juego: juego_memoria.nombre, aciertos: 7,  intentos: 10, fecha: 5.days.ago  },
  { alumno: 'Ana García Ruiz',     juego: juego_memoria.nombre, aciertos: 8,  intentos: 10, fecha: 1.day.ago   },
  # Carlos — nivel medio, buen rendimiento
  { alumno: 'Carlos López Sanz',   juego: juego_grid.nombre,    aciertos: 4,  intentos: 5,  fecha: 7.days.ago  },
  { alumno: 'Carlos López Sanz',   juego: juego_grid.nombre,    aciertos: 5,  intentos: 5,  fecha: 3.days.ago  },
  { alumno: 'Carlos López Sanz',   juego: juego_radar.nombre,   aciertos: 8,  intentos: 12, fecha: 2.days.ago  },
  # Pablo — nivel difícil, experto
  { alumno: 'Pablo Martín Gil',    juego: juego_radar.nombre,   aciertos: 10, intentos: 12, fecha: 6.days.ago  },
  { alumno: 'Pablo Martín Gil',    juego: juego_radar.nombre,   aciertos: 11, intentos: 12, fecha: 2.days.ago  },
  # Lucía — nivel fácil, recién empezando
  { alumno: 'Lucía Torres Vega',   juego: juego_memoria.nombre, aciertos: 3,  intentos: 10, fecha: 3.days.ago  },
  { alumno: 'Lucía Torres Vega',   juego: juego_memoria.nombre, aciertos: 5,  intentos: 10, fecha: 1.day.ago   }
]

sesiones_data.each do |datos|
  Sesion.create!(
    alumno:   datos[:alumno],
    juego:    datos[:juego],
    aciertos: datos[:aciertos],
    intentos: datos[:intentos],
    fecha:    datos[:fecha]
  )
end

puts "  ✓ #{Sesion.count} sesiones de ejemplo creadas"
puts ''
puts '✅ Base de datos lista.'
puts ''
puts '   Credenciales de prueba:'
puts '   admin@evin.es    / evin1234  (tecnico)'
puts '   garcia@evin.es   / evin1234  (profesor)'
puts '   lopez@evin.es    / evin1234  (técnico)'
puts '   martin@evin.es   / evin1234  (padre)'
