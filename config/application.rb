# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Utakata
end

class Utakata::Application < Rails::Application
  config.load_defaults 8.1
  config.time_zone = 'Tokyo'

  config.middleware.insert_before ActionDispatch::Static, Rack::Deflater
end
