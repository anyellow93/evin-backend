class CreateSesions < ActiveRecord::Migration[7.2]
  def change
    create_table :sesions do |t|
      t.string :alumno
      t.string :juego
      t.date :fecha
      t.integer :aciertos
      t.integer :intentos

      t.timestamps
    end
  end
end
