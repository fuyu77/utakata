# frozen_string_literal: true

require 'test_helper'

describe Users::RegistrationsController do
  include Devise::Test::IntegrationHelpers

  describe '#create' do
    it 'ユーザーを登録する' do
      previous_options = ActionMailer::Base.default_url_options
      ActionMailer::Base.default_url_options = { host: 'example.com' }

      begin
        assert_difference 'User.count', 1 do
          post user_registration_path, params: {
            user: {
              name: '新規ユーザー',
              email: 'new-user@example.com',
              password: 'password',
              password_confirmation: 'password'
            }
          }
        end
      ensure
        ActionMailer::Base.default_url_options = previous_options
      end

      assert_redirected_to root_path
      assert_not User.find_by!(email: 'new-user@example.com').confirmed?
    end

    it 'iOSアプリでは未確認ユーザーの登録後にログイン画面へ遷移する' do
      previous_options = ActionMailer::Base.default_url_options
      ActionMailer::Base.default_url_options = { host: 'example.com' }

      begin
        post user_registration_path,
             params: {
               user: {
                 name: '新規ユーザー',
                 email: 'native-new-user@example.com',
                 password: 'password',
                 password_confirmation: 'password'
               }
             },
             headers: { 'User-Agent' => 'Utakata Hotwire Native iOS; Turbo Native iOS;' }
      ensure
        ActionMailer::Base.default_url_options = previous_options
      end

      assert_redirected_to new_user_session_path
    end
  end

  describe '#update' do
    it '現在のパスワードなしでユーザー情報を更新する' do
      user = users(:hanako)
      sign_in user

      patch user_registration_path, params: { user: { name: '更新した名前' } }

      assert_redirected_to edit_user_registration_path
      assert_equal '更新した名前', user.reload.name
    end
  end

  describe '#destroy' do
    it 'ユーザーを削除してトップページへ遷移する' do
      user = users(:hanako)
      sign_in user

      assert_difference 'User.count', -1 do
        delete user_registration_path
      end

      assert_redirected_to root_path
    end
  end
end
