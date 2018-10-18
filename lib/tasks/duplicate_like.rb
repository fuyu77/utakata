users = User.where.not(id: 5).map{|t| t.id}
is_duplicate_like = true
users.each do |id|
  likes_count = Follow.where(followable_type: "Post", follower_id: id).group("follows.followable_id").count
  duplicate_like = likes_count.select{|k, v| v >= 2}
  if duplicate_like.present?
    is_duplicate_like = false
    puts id
    puts duplicate_like
  end
end
puts 'OK' if is_duplicate_like
