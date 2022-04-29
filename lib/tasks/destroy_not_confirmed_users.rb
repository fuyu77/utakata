# frozen_string_literal: true

User.order(:id).all[0..-2].each do |u|
  next if u.confirmed_at.present?

  Rails.logger.debug u.id
  Rails.logger.debug u.name
  u.destroy
end
