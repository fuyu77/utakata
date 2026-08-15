# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'
require 'minitest/spec'

class ActiveSupport::TestCase
  extend Minitest::Spec::DSL

  fixtures :all
end
