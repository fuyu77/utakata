# frozen_string_literal: true

require 'test_helper'

class HotwireNativeTest < ActionDispatch::IntegrationTest
  test 'iOS向けのパス設定が有効であること' do
    configuration = JSON.parse(Rails.public_path.join('configurations/ios_v1.json').read)

    assert_kind_of Array, configuration.fetch('rules')
  end

  test 'Hotwire Nativeアプリからのリクエストではbody要素にクラスを付与すること' do
    get about_index_path, headers: { 'User-Agent' => 'Utakata Hotwire Native iOS; Turbo Native iOS;' }

    assert_response :success
    assert_select 'body.hotwire-native'
    assert_select 'header.web-only'
  end

  test '通常ブラウザからのリクエストではbody要素にクラスを付与しないこと' do
    get about_index_path

    assert_response :success
    assert_select 'body.hotwire-native', count: 0
    assert_select 'header.web-only'
  end
end
