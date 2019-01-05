# frozen_string_literal: true

Post.all.each do |p|
  p.published_at = p.created_at
  p.save!
end
