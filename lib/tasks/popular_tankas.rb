popular_tankas = Follow.where(["followable_type = :type", {type: 'Post'}]).group('follows.followable_id').count('follows.followable_id')
popular_posts = popular_posts.select{|k, v| v >= 10}
popular_posts_ids = Hash[popular_posts.sort_by{ |_, v| -v }].keys
puts popular_posts_ids
