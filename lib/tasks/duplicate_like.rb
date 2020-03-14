# frozen_string_literal: true

users = User.all.map(&:id)
is_duplicate_like = true
users.each do |id|
  likes_count = Follow.where(followable_type: 'Post', follower_id: id).group('follows.followable_id').count
  duplicate_like = likes_count.select { |_, v| v >= 2 }
  next unless duplicate_like.present?

  is_duplicate_like = false
  puts id
  puts duplicate_like
end
puts is_duplicate_like
