# frozen_string_literal: true

class PopularPost < ApplicationRecord
  belongs_to :post

  validates :post, uniqueness: true
  validates :position, presence: true, uniqueness: true, numericality: { only_integer: true, greater_than: 0 }

  LIMIT = 30

  class << self
    def refresh!(now: Time.current)
      rows = ranked_posts(now:).each_with_index.map do |ranked_post, index|
        {
          post_id: ranked_post.post_id,
          position: index + 1
        }
      end

      transaction do
        delete_all
        insert_all!(rows) # rubocop:disable Rails/SkipsModelValidations
      end
    end

    private

    def ranked_posts(now:)
      find_by_sql(
        [
          ranked_posts_sql,
          {
            one_day_ago: now - 1.day,
            seven_days_ago: now - 7.days,
            limit: LIMIT
          }
        ]
      )
    end

    def ranked_posts_sql
      <<~SQL.squish
        WITH scored_posts AS (
          SELECT
            posts.id AS post_id,
            posts.user_id AS user_id,
            posts.created_at AS post_created_at,
            COUNT(follows.id) AS likes_count
          FROM posts
          INNER JOIN follows
            ON follows.followable_id = posts.id
           AND follows.followable_type = 'Post'
           AND follows.follower_type = 'User'
           AND follows.created_at >= :one_day_ago
          WHERE NOT EXISTS (
            SELECT 1
            FROM follows returned_follows
            INNER JOIN posts returned_followed_posts
              ON returned_followed_posts.id = returned_follows.followable_id
            WHERE returned_follows.followable_type = 'Post'
              AND returned_follows.follower_type = 'User'
              AND returned_follows.follower_id = posts.user_id
              AND returned_follows.created_at >= :seven_days_ago
              AND returned_followed_posts.user_id = follows.follower_id
          )
          GROUP BY posts.id, posts.user_id, posts.created_at
        ),
        author_ranked_posts AS (
          SELECT
            post_id,
            likes_count,
            post_created_at,
            ROW_NUMBER() OVER (
              PARTITION BY user_id
              ORDER BY likes_count DESC, post_created_at ASC, post_id ASC
            ) AS author_rank
          FROM scored_posts
        )
        SELECT post_id
        FROM author_ranked_posts
        WHERE author_rank = 1
        ORDER BY likes_count DESC, post_created_at ASC, post_id ASC
        LIMIT :limit
      SQL
    end
  end
end
