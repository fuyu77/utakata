# frozen_string_literal: true

require 'test_helper'

describe Users::SessionsController do
  include Devise::Test::IntegrationHelpers

  let(:native_headers) do
    { 'User-Agent' => 'Utakata Hotwire Native iOS; Turbo Native iOS;' }
  end

  describe '#create' do
    it 'iOSアプリでは認証確認画面へ遷移する' do
      post user_session_path,
           params: { user: { email: users(:hanako).email, password: 'password' } },
           headers: native_headers

      assert_redirected_to native_session_path
    end

    it 'Webブラウザではトップページへ遷移する' do
      post user_session_path,
           params: { user: { email: users(:hanako).email, password: 'password' } }

      assert_redirected_to root_path
    end
  end

  describe '#destroy' do
    it 'iOSアプリでは認証確認画面へ遷移する' do
      sign_in users(:hanako)

      delete destroy_user_session_path, headers: native_headers

      assert_redirected_to native_session_path
    end

    it 'Webブラウザではトップページへ遷移する' do
      sign_in users(:hanako)

      delete destroy_user_session_path

      assert_redirected_to root_path
    end
  end
end
