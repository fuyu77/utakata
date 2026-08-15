# frozen_string_literal: true

require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  before do
    @user = users(:hanako)
    @followee = users(:taro)
    sign_in @user
  end

  describe '#create' do
    it 'ユーザーをフォローする' do
      assert_difference 'Follow.count', 1 do
        post relationships_path, params: { user_id: @followee.id }, as: :turbo_stream
      end

      assert_response :success
      assert @user.following?(@followee)
    end

    it 'フォロー済みのユーザーを重複してフォローしない' do
      @user.follow(@followee)

      assert_no_difference 'Follow.count' do
        post relationships_path, params: { user_id: @followee.id }, as: :turbo_stream
      end

      assert_response :success
    end
  end

  describe '#destroy' do
    it 'ユーザーのフォローを外す' do
      @user.follow(@followee)

      assert_difference 'Follow.count', -1 do
        delete relationship_path(@followee), as: :turbo_stream
      end

      assert_response :success
      assert_not @user.following?(@followee)
    end
  end
end
