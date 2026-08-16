# frozen_string_literal: true

require 'test_helper'

describe Posts::MySearchController do
  include Devise::Test::IntegrationHelpers

  describe '#index' do
    it '自分の投稿をキーワードで検索する' do
      sign_in users(:hanako)

      get posts_my_search_index_path(keyword: '春')

      assert_response :success
      assert_includes response.body, posts(:hanako_first).tanka
      assert_not_includes response.body, posts(:taro_first).tanka
    end
  end
end
