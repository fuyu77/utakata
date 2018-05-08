class AddProfileAndUrlToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :profile, :string, default: ""
    add_column :users, :url, :string, default: ""
  end
end
