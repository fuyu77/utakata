# frozen_string_literal: true

require 'test_helper'

describe Posts::SearchController do
  include Devise::Test::IntegrationHelpers

  describe '#index' do
    it '投稿をキーワードで検索する' do
      sign_in users(:hanako)

      get posts_search_index_path(keyword: '秋')

      assert_response :success
      assert_includes response.body, posts(:taro_first).tanka
      assert_not_includes response.body, posts(:hanako_first).tanka
    end

    it 'キーワードが空の場合はユーザー一覧へ遷移する' do
      sign_in users(:hanako)

      get posts_search_index_path(keyword: '')

      assert_redirected_to users_path
    end
  end
end
