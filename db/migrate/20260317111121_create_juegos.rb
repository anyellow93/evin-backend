class CreateJuegos < ActiveRecord::Migration[7.2]
  def change
    create_table :juegos do |t|
      t.string :nombre
      t.text :descripcion
      t.string :img
      t.string :nivel
      t.string :tipo

      t.timestamps
    end
  end
end
