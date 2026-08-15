# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # test/fixtures/*.ymlにあるすべてのフィクスチャをアルファベット順に読み込む。
  fixtures :all

  # すべてのテストで使用するヘルパーメソッドはここに追加する。
end
