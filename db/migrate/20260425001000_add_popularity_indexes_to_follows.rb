# frozen_string_literal: true

class AddPopularityIndexesToFollows < ActiveRecord::Migration[8.0]
  def change
    add_index :follows,
              %i[followable_type follower_type created_at followable_id follower_id],
              name: 'index_follows_on_favorite_popularity'
    add_index :follows,
              %i[follower_id followable_type follower_type created_at followable_id],
              name: 'index_follows_on_recent_favorites_by_user'
  end
end
