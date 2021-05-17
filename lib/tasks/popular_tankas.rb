# frozen_string_literal: true

popular_records = Follow.select('
                          follows.followable_id,
                          MIN(posts.user_id) as user_id,
                          COUNT(follows.id) as favorites_count
                        ')
                        .joins('INNER JOIN posts ON posts.id = follows.followable_id')
                        .where(follows: { followable_type: 'Post' })
                        .where.not(posts: { user_id: [5, 1046] })
                        .group('follows.followable_id')
                        .having('COUNT(follows.id) >= 10')

popular_posts = popular_records.each_with_object([]) do |record, result|
  next if record.user_id == 857 && record.favorites_count <= 12
  next if record.user_id.in?(440, 2146) && record.favorites_count <= 11

  result << {
    id: record.followable_id,
    user_id: record.user_id,
    favorites_count: record.favorites_count
  }
end

p(popular_posts.map { |post| post[:id] })
p popular_posts.length

posts_count_per_user = popular_posts.each_with_object({}) do |post, result|
  if result[post[:user_id]]
    result[post[:user_id]] += 1
  else
    result[post[:user_id]] = 1
  end
end

sorted_posts_count_per_user = posts_count_per_user.sort { |(_, v1), (_, v2)| v2 <=> v1 }.to_h

p sorted_posts_count_per_user
