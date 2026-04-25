# frozen_string_literal: true

class CreatePopularPosts < ActiveRecord::Migration[8.0]
  def change
    create_table :popular_posts do |t|
      t.references :post, null: false, foreign_key: { on_delete: :cascade }, index: { unique: true }
      t.integer :position, null: false

      t.timestamps
    end

    add_index :popular_posts, :position, unique: true
  end
end
