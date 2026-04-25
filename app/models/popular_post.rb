# frozen_string_literal: true

class PopularPost < ApplicationRecord
  belongs_to :post

  validates :position, presence: true, numericality: { only_integer: true, greater_than: 0 }

  class << self
    def rebuild!(now: Time.current, limit: 30)
      popular_posts = aggregated_posts(now:, limit:)

      transaction do
        delete_all

        popular_posts.each.with_index(1) do |popular_post, position|
          create!(
            post_id: popular_post.post_id,
            position:
          )
        end
      end
    end

    private

    def aggregated_posts(now:, limit:)
      recent_since = now - 1.day
      reciprocal_since = now - 7.days

      Post.joins(<<~SQL.squish)
        INNER JOIN follows recent_favorites
          ON recent_favorites.followable_type = 'Post'
          AND recent_favorites.followable_id = posts.id
          AND recent_favorites.follower_type = 'User'
      SQL
          .where(recent_favorites: { created_at: recent_since..now })
          .where(<<~SQL.squish, reciprocal_since:)
            NOT EXISTS (
              SELECT 1
              FROM follows author_favorites
              INNER JOIN posts liked_posts
                ON liked_posts.id = author_favorites.followable_id
              WHERE author_favorites.followable_type = 'Post'
                AND author_favorites.follower_type = 'User'
                AND author_favorites.follower_id = posts.user_id
                AND author_favorites.created_at >= :reciprocal_since
                AND liked_posts.user_id = recent_favorites.follower_id
            )
          SQL
          .group('posts.id')
          .select('posts.id AS post_id')
          .order(Arel.sql('COUNT(recent_favorites.id) DESC'))
          .order(:created_at)
          .limit(limit)
    end
  end
end
