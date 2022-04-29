# frozen_string_literal: true

class AddOmniAuthColumnsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :uid, :string, null: false, default: '' # rubocop:disable Rails/BulkChangeTable
    add_column :users, :provider, :string, null: false, default: ''
    add_index :users, %i[uid provider]
  end
end
