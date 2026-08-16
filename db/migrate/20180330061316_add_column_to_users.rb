# frozen_string_literal: true

class AddColumnToUsers < ActiveRecord::Migration[5.1]
  def change
    change_table :users, bulk: true do |t|
      t.string :name, null: false, default: ''
      t.string :profile, default: ''
      t.string :twitter_id, default: ''
      t.index :name
    end
  end
end
