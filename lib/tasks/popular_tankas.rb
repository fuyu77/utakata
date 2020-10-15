# frozen_string_literal: true

favorites_count = Follow.joins('INNER JOIN posts ON posts.id = follows.followable_id')
                        .where(follows: { followable_type: 'Post' })
                        .where.not(posts: { user_id: [5, 1046] })
                        .group('follows.followable_id')
                        .count('follows.followable_id')
popular_tankas = favorites_count.select { |_, v| v >= 10 }
sorted_popular_tankas = Hash[popular_tankas.sort { |(_, v1), (_, v2)| v2 <=> v1 }]
p sorted_popular_tankas
p sorted_popular_tankas.length
