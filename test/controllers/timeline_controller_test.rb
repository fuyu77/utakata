# frozen_string_literal: true

require 'test_helper'

describe TimelineController do
  include Devise::Test::IntegrationHelpers

  describe '#index' do
    it '自分とフォロー中のユーザーの投稿を表示する' do
      user = users(:hanako)
      user.follow(users(:taro))
      sign_in user

      get timeline_index_path

      assert_response :success
      rendered_posts = [posts(:hanako_first), posts(:taro_first), posts(:jiro_first)].map do |post|
        response.body.include?(post.tanka)
      end

      assert_equal [true, true, false], rendered_posts
    end
  end
end
