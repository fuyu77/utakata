# frozen_string_literal: true

require 'test_helper'

class UsersConfirmationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  describe '#show' do
    it '確認トークンが不正な場合はトップページへ遷移する' do
      get user_confirmation_path(confirmation_token: 'invalid-token')

      assert_redirected_to root_path
    end

    it '確認トークンが正しい場合はユーザーを確認済みにしてログインする' do
      user = User.new(name: '未確認ユーザー', email: 'unconfirmed@example.com', password: 'password')
      user.skip_confirmation_notification!
      user.save!
      user.send(:generate_confirmation_token)
      token = user.instance_variable_get(:@raw_confirmation_token)
      user.save!(validate: false)

      get user_confirmation_path(confirmation_token: token)

      assert_redirected_to root_path
      assert_predicate user.reload, :confirmed?
      assert_equal user.id, controller.current_user.id
    end
  end

  describe '#new' do
    it 'トップページへ遷移する' do
      get new_user_confirmation_path

      assert_redirected_to root_path
    end
  end
end
