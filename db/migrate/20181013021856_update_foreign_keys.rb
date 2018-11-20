# frozen_string_literal: true

class UpdateForeignKeys < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :follows, :users
    remove_foreign_key :posts, :users

    add_foreign_key :follows, :users, on_delete: :cascade
    add_foreign_key :posts, :users, on_delete: :cascade
  end
end
