# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'
require 'minitest/spec'

class ActiveSupport::TestCase
  fixtures :all
end

class ModelSpec < ActiveSupport::TestCase
  extend Minitest::Spec::DSL
end

Minitest::Spec.register_spec_type(ModelSpec) do |description|
  model = description.is_a?(Class) && description < ApplicationRecord
  concern = description.is_a?(Module) && description.singleton_class < ActiveSupport::Concern

  model || concern
end
