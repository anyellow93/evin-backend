class RenameAndAddReferencesToSesions < ActiveRecord::Migration[7.2]
  def change
    rename_column :sesions, :alumno, :alumno_nombre
    rename_column :sesions, :juego,  :juego_nombre
    add_reference :sesions, :juego, foreign_key: true, null: true

    reversible do |dir|
      dir.up do
        execute <<~SQL
          UPDATE sesions
          SET juego_id = juegos.id
          FROM juegos
          WHERE sesions.juego_nombre = juegos.nombre
        SQL
      end
    end
  end
end
