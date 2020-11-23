# frozen_string_literal: true

exluded_post_ids = Follow.where(followable_type: 'Post', follower_id: 5).pluck(:followable_id)
exluded_post_ids += Post.where(user_id: 5).pluck(:id)
posts_with_like_count = Follow.where(followable_type: 'Post')
                              .where.not(followable_id: exluded_post_ids)
                              .group('follows.followable_id')
                              .count('follows.followable_id')
posts = posts_with_like_count.select { |_, v| v >= 9 }
p posts
p posts.length
