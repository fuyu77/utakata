# frozen_string_literal: true

require 'test_helper'

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  describe '#index' do
    it '通知を表示して未読通知を既読にする' do
      user = users(:hanako)
      post = posts(:hanako_first)
      follow = Follow.create!(follower: users(:taro), followable: post, user_id: user.id)
      sign_in user

      get notifications_path

      assert_response :success
      assert_predicate follow.reload, :read?
    end
  end
end
