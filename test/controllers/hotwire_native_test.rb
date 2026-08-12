# frozen_string_literal: true

require 'test_helper'

class HotwireNativeTest < ActionDispatch::IntegrationTest
  test 'bundles the same path configuration in Rails and iOS' do
    server_configuration = Rails.public_path.join('configurations/ios_v1.json').read
    bundled_configuration = Rails.root.join('ios/Utakata/path-configuration.json').read

    assert_equal JSON.parse(server_configuration), JSON.parse(bundled_configuration)
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
