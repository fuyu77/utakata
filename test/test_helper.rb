# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'
require 'minitest/spec'

class ActiveSupport::TestCase
  extend Minitest::Spec::DSL

  fixtures :all
end

Minitest::Spec.register_spec_type(//, ActiveSupport::TestCase)

Minitest::Spec.register_spec_type(ActionDispatch::IntegrationTest) do |description|
  description.is_a?(Class) && description < ActionController::Base
end
