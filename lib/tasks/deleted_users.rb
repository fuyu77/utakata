# frozen_string_literal: true

users = User.all.pluck(:id)
last_user = User.last.id
original_users = [*(1..last_user)]
puts(original_users.reject { |user| users.include?(user) })
