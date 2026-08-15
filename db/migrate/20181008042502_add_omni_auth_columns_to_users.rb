# frozen_string_literal: true

class AddOmniAuthColumnsToUsers < ActiveRecord::Migration[5.1]
  def change
    change_table :users, bulk: true do |t|
      t.string :uid, null: false, default: ''
      t.string :provider, null: false, default: ''
      t.index %i[uid provider]
    end
  end
end
