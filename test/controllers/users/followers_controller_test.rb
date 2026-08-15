# frozen_string_literal: true

require 'test_helper'

describe Users::FollowersController do
  describe '#index' do
    it 'フォロワーを表示する' do
      user = users(:hanako)
      users(:taro).follow(user)

      get users_user_followers_path(user)

      assert_response :success
      assert_includes response.body, users(:taro).name
      assert_not_includes response.body, users(:jiro).name
    end
  end
end
