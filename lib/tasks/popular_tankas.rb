# frozen_string_literal: true

favorites_count = Follow.where(followable_type: 'Post').group('follows.followable_id').count('follows.followable_id')
popular_tankas = favorites_count.select { |_, v| v >= 10 }
sorted_popular_tankas = Hash[popular_tankas.sort { |(_, v1), (_, v2)| v2 <=> v1 }]
p sorted_popular_tankas
p sorted_popular_tankas.length
