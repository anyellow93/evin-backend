class AddAlumnoIdToSesions < ActiveRecord::Migration[7.2]
  def change
    add_reference :sesions, :alumno, foreign_key: true, null: true
    # null: true para no romper las sesiones existentes que solo tienen nombre
  end
end
