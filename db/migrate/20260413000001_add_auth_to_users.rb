class AddAuthToUsers < ActiveRecord::Migration[7.2]
  def change
    # Añadir campos de autenticación y rol a users
    add_column :users, :email, :string
    add_column :users, :password_digest, :string
    add_column :users, :rol, :string, default: 'alumno'
    # rol puede ser: 'alumno', 'profesor', 'tecnico', 'padre'

    add_index :users, :email, unique: true

    # Arreglar sesiones: usar user_id en lugar de string suelto
    add_reference :sesions, :user, foreign_key: true
    # Nota: mantenemos la columna :alumno por ahora para no romper nada,
    # la eliminamos en una migración posterior cuando migremos los datos
  end
end
