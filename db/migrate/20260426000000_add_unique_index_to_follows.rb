# frozen_string_literal: true

class AddUniqueIndexToFollows < ActiveRecord::Migration[8.1]
  def up
    add_index :follows,
              %i[follower_id follower_type followable_id followable_type],
              unique: true,
              name: 'index_follows_on_follower_and_followable'
  end

  def down
    remove_index :follows, name: 'index_follows_on_follower_and_followable'
  end
end
