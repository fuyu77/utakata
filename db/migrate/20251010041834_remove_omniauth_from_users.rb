# frozen_string_literal: true

class RemoveOmniauthFromUsers < ActiveRecord::Migration[7.0]
  def up
    remove_index :users, %i[uid provider], if_exists: true

    change_table :users, bulk: true do |t|
      t.remove :provider if column_exists?(:users, :provider)
      t.remove :uid if column_exists?(:users, :uid)
    end
  end

  def down
    change_table :users, bulk: true do |t|
      t.string :provider, default: '', null: false unless column_exists?(:users, :provider)
      t.string :uid, default: '', null: false unless column_exists?(:users, :uid)
    end

    add_index :users, %i[uid provider] unless index_exists?(:users, %i[uid provider])
  end
end
