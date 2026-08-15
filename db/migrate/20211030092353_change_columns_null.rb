# frozen_string_literal: true

class ChangeColumnsNull < ActiveRecord::Migration[6.1]
  def change
    change_table :posts, bulk: true do |t|
      t.change_null :user_id, false
      t.change_null :tanka, false, ''
      t.change_null :published_at, false
    end
  end
end
