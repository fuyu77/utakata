# frozen_string_literal: true

class AddUniqueIndexToFollows < ActiveRecord::Migration[8.1]
  def up
    execute <<~SQL.squish
      DELETE FROM follows
      WHERE id IN (
        SELECT id
        FROM (
          SELECT
            id,
            ROW_NUMBER() OVER (
              PARTITION BY follower_id, follower_type, followable_id, followable_type
              ORDER BY id
            ) AS row_number
          FROM follows
        ) duplicate_follows
        WHERE duplicate_follows.row_number > 1
      )
    SQL

    add_index :follows,
              %i[follower_id follower_type followable_id followable_type],
              unique: true,
              name: 'index_follows_on_follower_and_followable'
  end

  def down
    remove_index :follows, name: 'index_follows_on_follower_and_followable'
  end
end
