class DropLegacyApiTables < ActiveRecord::Migration[7.2]
  def change
    drop_table :api_sesiones, if_exists: true
    drop_table :api_alumnos,  if_exists: true
    drop_table :api_juegos,   if_exists: true
  end
end
