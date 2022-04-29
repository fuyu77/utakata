# frozen_string_literal: true

post_ids = Follow.where(followable_type: 'Post', follower_id: 5).pluck(:followable_id)
posts_with_like_count = Follow.where(followable_type: 'Post', followable_id: post_ids)
                              .group('follows.followable_id')
                              .count('follows.followable_id')
posts = posts_with_like_count.select { |_, v| v <= 9 }
Rails.logger.debug posts.keys.join(',')
Rails.logger.debug posts.length
