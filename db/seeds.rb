# db/seeds.rb
# Ejecutar con: rails db:seed

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
    nombre:      'Exploraciones',
    descripcion: 'El alumno debe localizar un estímulo objetivo entre una cuadrícula de imágenes distractoras. Entrena los recorridos visuales y la discriminación figura-fondo.',
    img:         'img/juegos/radar.png',
    nivel:       'Difícil',
    tipo:        'Atención visual'
  },
  {
    nombre:      'Encuentra las diferencias',
    descripcion: 'El alumno observa dos imágenes casi idénticas y debe localizar todas las diferencias entre ellas. Trabaja la discriminación visual, la atención sostenida y los recorridos visuales.',
    img:         'img/juegos/diferencias.png',
    nivel:       'Medio',
    tipo:        'Atención visual'
  },
  {
  nombre:      'Cierre Visual',
  descripcion: 'Observa una forma incompleta y encuentra la forma completa entre los distractores. Trabaja la discriminación visual fina y el reconocimiento de formas.',
  img:         'img/juegos/rasgos.png',
  nivel:       'Medio',
  tipo:        'Atención visual'
  },
  {
  nombre:      'Puzzle',
  descripcion: 'Reconstruye la ilustración colocando cada pieza en su posición correcta. Trabaja la percepción espacial, la memoria visual y la atención.',
  img:         'img/juegos/puzzle.png',
  nivel:       'Medio',
  tipo:        'Percepción espacial'
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

puts "  ✓ #{Juego.count} juegos creados/existentes"

# ─── USUARIOS ────────────────────────────────────────────────────────────────

usuarios_data = [
  { nombre: 'Admin EVIN',       email: 'admin@evin.es',  password: 'Evin1234!', rol: 'tecnico'  },
  { nombre: 'Profesora García', email: 'garcia@evin.es', password: 'Evin1234!', rol: 'profesor' },
  { nombre: 'Técnico López',    email: 'lopez@evin.es',  password: 'Evin1234!', rol: 'tecnico'  },
  { nombre: 'Familia Martín',   email: 'martin@evin.es', password: 'Evin1234!', rol: 'padre'    }
]

usuarios_data.each do |datos|
  User.find_or_create_by!(email: datos[:email]) do |u|
    u.nombre   = datos[:nombre]
    u.password = datos[:password]
    u.rol      = datos[:rol]
  end
end

puts "  ✓ #{User.count} usuarios creados/existentes"

# ─── ALUMNOS ─────────────────────────────────────────────────────────────────

alumnos_data = [
  { nombre: 'Ana García Ruiz',     edad: 7,  dificultad: 'Fácil',   curso: '1º Primaria', progreso: 40 },
  { nombre: 'Carlos López Sanz',   edad: 9,  dificultad: 'Medio',   curso: '3º Primaria', progreso: 65 },
  { nombre: 'María Sánchez Pérez', edad: 8,  dificultad: 'Fácil',   curso: '2º Primaria', progreso: 55 },
  { nombre: 'Pablo Martín Gil',    edad: 11, dificultad: 'Difícil', curso: '5º Primaria', progreso: 80 },
  { nombre: 'Lucía Torres Vega',   edad: 6,  dificultad: 'Fácil',   curso: '1º Primaria', progreso: 25 },
  { nombre: 'Diego Fernández',     edad: 10, dificultad: 'Medio',   curso: '4º Primaria', progreso: 70 }
]

alumnos_data.each do |datos|
  Alumno.find_or_create_by!(nombre: datos[:nombre]) do |a|
    a.edad       = datos[:edad]
    a.dificultad = datos[:dificultad]
    a.curso      = datos[:curso]
    a.progreso   = datos[:progreso]
  end
end

puts "  ✓ #{Alumno.count} alumnos creados/existentes"

# ─── SESIONES DE EJEMPLO ─────────────────────────────────────────────────────

begin
  cols = Sesion.column_names
  puts "  Columnas de sesions: #{cols.join(', ')}"

  if cols.include?('alumno_id') && cols.include?('juego_id')
    # BD local: usa alumno_id y juego_id (enteros)
    ana    = Alumno.find_by(nombre: 'Ana García Ruiz')
    carlos = Alumno.find_by(nombre: 'Carlos López Sanz')
    pablo  = Alumno.find_by(nombre: 'Pablo Martín Gil')
    lucia  = Alumno.find_by(nombre: 'Lucía Torres Vega')
    diego  = Alumno.find_by(nombre: 'Diego Fernández')
    maria  = Alumno.find_by(nombre: 'María Sánchez Pérez')

    j_mem  = Juego.find_by(nombre: 'Encuentra las parejas')
    j_grid = Juego.find_by(nombre: 'Recuerda las casillas')
    j_rad  = Juego.find_by(nombre: 'Exploraciones')
    j_dif  = Juego.find_by(nombre: 'Encuentra las diferencias')

    [
      { alumno_id: ana.id,    juego_id: j_mem.id,  aciertos: 6,  intentos: 10, fecha: 10.days.ago },
      { alumno_id: ana.id,    juego_id: j_mem.id,  aciertos: 7,  intentos: 10, fecha: 5.days.ago  },
      { alumno_id: ana.id,    juego_id: j_mem.id,  aciertos: 8,  intentos: 10, fecha: 1.day.ago   },
      { alumno_id: carlos.id, juego_id: j_grid.id, aciertos: 4,  intentos: 5,  fecha: 7.days.ago  },
      { alumno_id: carlos.id, juego_id: j_grid.id, aciertos: 5,  intentos: 5,  fecha: 3.days.ago  },
      { alumno_id: carlos.id, juego_id: j_rad.id,  aciertos: 8,  intentos: 12, fecha: 2.days.ago  },
      { alumno_id: pablo.id,  juego_id: j_rad.id,  aciertos: 10, intentos: 12, fecha: 6.days.ago  },
      { alumno_id: pablo.id,  juego_id: j_rad.id,  aciertos: 11, intentos: 12, fecha: 2.days.ago  },
      { alumno_id: lucia.id,  juego_id: j_mem.id,  aciertos: 3,  intentos: 10, fecha: 3.days.ago  },
      { alumno_id: lucia.id,  juego_id: j_mem.id,  aciertos: 5,  intentos: 10, fecha: 1.day.ago   },
      { alumno_id: diego.id,  juego_id: j_dif.id,  aciertos: 3,  intentos: 5,  fecha: 4.days.ago  },
      { alumno_id: maria.id,  juego_id: j_dif.id,  aciertos: 5,  intentos: 7,  fecha: 2.days.ago  }
    ].each { |s| Sesion.create!(s) }

  
  end

  puts "  ✓ #{Sesion.count} sesiones creadas"
rescue => e
  puts "  ⚠️  Sesiones omitidas: #{e.message}"
end

puts '✅ Base de datos lista.'
