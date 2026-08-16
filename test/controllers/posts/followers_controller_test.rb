# frozen_string_literal: true

require 'test_helper'

describe Posts::FollowersController do
  describe '#index' do
    it '投稿をいいねしたユーザーを表示する' do
      post_record = posts(:hanako_first)
      users(:taro).follow(post_record)

      get posts_post_followers_path(post_record)

      assert_response :success
      assert_includes response.body, users(:taro).name
    end
  end
end
