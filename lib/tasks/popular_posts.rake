# frozen_string_literal: true

namespace :popular_posts do
  desc '人気の歌を集計し直す'
  task refresh: :environment do
    popularity_sql = <<~SQL.squish
      SELECT ranked_posts.post_id, ranked_posts.favorites_count
      FROM (
        SELECT
          counted_posts.post_id,
          counted_posts.user_id,
          counted_posts.favorites_count,
          ROW_NUMBER() OVER (
            PARTITION BY counted_posts.user_id
            ORDER BY counted_posts.favorites_count DESC, counted_posts.created_at ASC, counted_posts.post_id ASC
          ) AS user_post_rank
        FROM (
          SELECT
            posts.id AS post_id,
            posts.user_id,
            posts.created_at,
            COUNT(follows.id) AS favorites_count
          FROM posts
          INNER JOIN follows
            ON follows.followable_type = 'Post'
            AND follows.followable_id = posts.id
            AND follows.follower_type = 'User'
            AND follows.created_at >= :favorited_since
          WHERE NOT EXISTS (
            SELECT 1
            FROM follows recent_author_favorites
            INNER JOIN posts favorited_posts
              ON favorited_posts.id = recent_author_favorites.followable_id
            WHERE recent_author_favorites.followable_type = 'Post'
              AND recent_author_favorites.follower_type = 'User'
              AND recent_author_favorites.follower_id = posts.user_id
              AND recent_author_favorites.created_at >= :reciprocal_since
              AND favorited_posts.user_id = follows.follower_id
          )
          GROUP BY posts.id, posts.user_id, posts.created_at
        ) counted_posts
      ) ranked_posts
      WHERE ranked_posts.user_post_rank = 1
      ORDER BY ranked_posts.favorites_count DESC, ranked_posts.post_id ASC
      LIMIT 30
    SQL

    popular_posts = ApplicationRecord.sanitize_sql(
      [
        popularity_sql,
        { favorited_since: 1.day.ago, reciprocal_since: 7.days.ago }
      ]
    )

    PopularPost.transaction do
      PopularPost.delete_all

      ApplicationRecord.connection.select_all(popular_posts).each.with_index(1) do |popular_post, position|
        PopularPost.create!(
          post_id: popular_post['post_id'],
          position:,
          favorites_count: popular_post['favorites_count']
        )
      end
    end

    Rails.logger.info "人気の歌を#{PopularPost.count}件集計しました"
  end
end
