class AddUserIdToAlumnos < ActiveRecord::Migration[7.2]
  def change
    add_reference :alumnos, :user, foreign_key: true, null: true
    # null: true porque los alumnos creados manualmente por un profesor
    # no tienen cuenta de usuario asociada
  end
end
