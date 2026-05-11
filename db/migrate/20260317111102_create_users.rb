class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :nombre

      t.timestamps
    end
    add_index :users, :nombre, unique: true
  end
end
