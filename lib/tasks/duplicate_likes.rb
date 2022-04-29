# frozen_string_literal: true

user_ids = User.pluck(:id)
is_duplicate_like = false
user_ids.each do |id|
  likes_count = Follow.where(followable_type: 'Post', follower_id: id).group('follows.followable_id').count
  duplicate_like = likes_count.select { |_, v| v >= 2 }
  next if duplicate_like.blank?

  is_duplicate_like = true
  Rails.logger.debug id
  Rails.logger.debug duplicate_like
end
Rails.logger.debug is_duplicate_like ? '重複あり' : '重複なし'
