class CreateAlumnos < ActiveRecord::Migration[7.2]
  def change
    create_table :alumnos do |t|
      t.string :nombre
      t.integer :edad
      t.string :dificultad
      t.string :curso
      t.integer :progreso

      t.timestamps
    end
  end
end
