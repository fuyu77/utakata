# frozen_string_literal: true

require 'test_helper'

describe UsersController do
  include Devise::Test::IntegrationHelpers

  describe '#index' do
    it '未ログインの場合はログイン画面へ遷移する' do
      get users_path

      assert_redirected_to new_user_session_path
    end

    it 'ユーザー一覧を表示する' do
      sign_in users(:hanako)

      get users_path

      assert_response :success
      assert_includes response.body, users(:taro).name
    end
  end

  describe '#show' do
    it 'ユーザーと投稿を表示する' do
      user = users(:hanako)

      get user_path(user)

      assert_response :success
      assert_includes response.body, user.name
      assert_includes response.body, posts(:hanako_first).tanka
    end

    it 'iOSアプリでは自分のページにログアウト導線を表示する' do
      user = users(:hanako)
      sign_in user

      get user_path(user), headers: { 'User-Agent' => 'Utakata Hotwire Native iOS; Turbo Native iOS;' }

      assert_response :success
      assert_select '.hotwire-native-only a[href=?]', destroy_user_session_path, text: 'ログアウト'
    end
  end
end
