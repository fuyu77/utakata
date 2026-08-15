# frozen_string_literal: true

require 'test_helper'

describe Users::FolloweesController do
  describe '#index' do
    it 'フォロー中のユーザーを表示する' do
      user = users(:hanako)
      user.follow(users(:taro))

      get users_user_followees_path(user)

      assert_response :success
      assert_includes response.body, users(:taro).name
      assert_not_includes response.body, users(:jiro).name
    end
  end
end
