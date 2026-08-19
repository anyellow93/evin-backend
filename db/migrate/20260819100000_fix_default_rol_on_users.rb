class FixDefaultRolOnUsers < ActiveRecord::Migration[7.2]
  def change
    change_column_default :users, :rol, from: "profesor", to: "alumno"
  end
end
