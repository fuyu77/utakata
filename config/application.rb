# frozen_string_literal: true

require_relative 'boot'
require_relative '../lib/utakata'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

class Utakata::Application < Rails::Application
  config.load_defaults 8.1

  config.active_storage.variant_processor = :disabled
  config.middleware.insert_before ActionDispatch::Static, Rack::Deflater
  config.time_zone = 'Tokyo'
  config.yjit = true
end
