# frozen_string_literal: true

namespace :favorites do
  desc '同じユーザーが同じ投稿に多重いいねしている状態を検出する'
  task detect_duplicates: :environment do
    duplicated_favorites = Follow.where(followable_type: 'Post', follower_type: 'User')
                                 .group(:follower_id, :followable_id)
                                 .having('COUNT(*) > 1')
                                 .count

    if duplicated_favorites.empty?
      Rails.logger.info '多重いいねは検出されませんでした'
      next
    end

    Rails.logger.info "多重いいねを#{duplicated_favorites.size}件検出しました"

    duplicated_favorites.each do |(user_id, post_id), count|
      follow_ids = Follow.where(
        followable_type: 'Post',
        followable_id: post_id,
        follower_type: 'User',
        follower_id: user_id
      ).order(:id).pluck(:id)

      user = User.find_by(id: user_id)
      post = Post.find_by(id: post_id)

      Rails.logger.info(
        [
          "user_id=#{user_id}",
          "user_name=#{user&.name}",
          "post_id=#{post_id}",
          "favorites_count=#{count}",
          "follow_ids=#{follow_ids.join(',')}",
          "post=#{post&.tanka_text}"
        ].join(' ')
      )
    end
  end
end
