# frozen_string_literal: true

class AddColumnToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :name, :string, null: false, default: '' # rubocop:disable Rails/BulkChangeTable
    add_column :users, :profile, :string, default: ''
    add_column :users, :twitter_id, :string, default: ''
    add_index :users, :name
  end
end
