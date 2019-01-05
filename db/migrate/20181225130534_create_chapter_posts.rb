class CreateChapterPosts < ActiveRecord::Migration[5.1]
  def change
    create_table :chapter_posts do |t|
      t.references :chapter, index: true, foreign_key: true
      t.references :post, index: true, foreign_key: true
      t.integer :order
      t.timestamps
    end
  end
end
