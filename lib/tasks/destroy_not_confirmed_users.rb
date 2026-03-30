# frozen_string_literal: true

User.where(confirmed_at: nil).where(created_at: ...1.day.ago).find_each do |user|
  Rails.logger.info user.id
  Rails.logger.info user.email
  Rails.logger.info user.name
  user.destroy!
end
