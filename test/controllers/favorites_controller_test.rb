# frozen_string_literal: true

require 'test_helper'

describe FavoritesController do
  include Devise::Test::IntegrationHelpers

  before do
    @user = users(:hanako)
    @post = posts(:taro_first)
    sign_in @user
  end

  describe '#index' do
    it 'いいねした投稿を表示する' do
      @user.follow(@post)

      get favorites_path

      assert_response :success
      assert_includes response.body, @post.tanka
    end
  end

  describe '#create' do
    it '投稿をいいねする' do
      assert_difference 'Follow.count', 1 do
        post favorites_path, params: { post_id: @post.id }, as: :turbo_stream
      end

      assert_response :success
      assert @user.following?(@post)
    end

    it 'いいね済みの投稿には重複していいねしない' do
      @user.follow(@post)

      assert_no_difference 'Follow.count' do
        post favorites_path, params: { post_id: @post.id }, as: :turbo_stream
      end

      assert_response :success
    end
  end

  describe '#destroy' do
    it '投稿のいいねを外す' do
      @user.follow(@post)

      assert_difference 'Follow.count', -1 do
        delete favorite_path(@post), as: :turbo_stream
      end

      assert_response :success
      assert_not @user.following?(@post)
    end
  end
end
