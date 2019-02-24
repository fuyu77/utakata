# frozen_string_literal: true

User.all[0..-2].each do |u|
  next unless u.confirmed_at.blank?

  p u.id
  p u.name
  u.destroy
end
