favorites_count = Follow.where(["followable_type = :type", {type: 'Post'}]).group('follows.followable_id').count('follows.followable_id')
popular_tankas = favorites_count.select{|k, v| v >= 10}
sorted_popular_tankas = Hash[popular_tankas.sort{ |(k1, v1), (k2, v2)| v2 <=> v1 }]
puts sorted_popular_tankas
