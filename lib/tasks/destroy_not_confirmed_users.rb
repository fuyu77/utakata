# frozen_string_literal: true

User.where(confirmed_at: nil).where('created_at < ?', 1.day.ago).each do |user|
  Rails.logger.debug user.id
  Rails.logger.debug user.name
  user.destroy!
end
