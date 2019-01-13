# frozen_string_literal: true

User.all.each do |u|
  if u.confirmed_at.blank?
    p u.id
    p u.name
    u.destroy
  end
end
