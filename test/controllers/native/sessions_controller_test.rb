# frozen_string_literal: true

require 'test_helper'

describe Native::SessionsController do
  include Devise::Test::IntegrationHelpers

  describe '#show' do
    it '未ログインの場合はログイン画面へ遷移する' do
      get native_session_path

      assert_redirected_to new_user_session_path
    end

    it 'ログイン済みの場合は認証済みのレスポンスを返す' do
      sign_in users(:hanako)

      get native_session_path

      assert_response :success
    end
  end
end
