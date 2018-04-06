class AddNameToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :name, :string, null: false, defult: ""
    add_index :users, :name, unique: true
  end
end
