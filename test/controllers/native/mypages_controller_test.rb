# frozen_string_literal: true

require 'test_helper'

describe Native::MypagesController do
  include Devise::Test::IntegrationHelpers

  describe '#show' do
    it '未ログインの場合はログイン画面へ遷移する' do
      get native_mypage_path

      assert_redirected_to new_user_session_path
    end

    it 'ログイン済みの場合はユーザーページへ遷移する' do
      user = users(:hanako)
      sign_in user

      get native_mypage_path

      assert_redirected_to user_path(user), status: :see_other
    end
  end
end
