# frozen_string_literal: true

require 'test_helper'

class HotwireNativeTest < ActionDispatch::IntegrationTest
  test 'has a valid path configuration for iOS' do
    configuration = JSON.parse(Rails.public_path.join('configurations/ios_v1.json').read)

    assert_kind_of Array, configuration.fetch('rules')
  end

  test 'marks requests from the Hotwire Native app' do
    get about_index_path, headers: { 'User-Agent' => 'Utakata Hotwire Native iOS; Turbo Native iOS;' }

    assert_response :success
    assert_select 'body.hotwire-native'
  end

  test 'does not mark regular browser requests as native' do
    get about_index_path

    assert_response :success
    assert_select 'body.hotwire-native', count: 0
  end
end
