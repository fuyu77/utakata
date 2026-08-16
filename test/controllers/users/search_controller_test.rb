# frozen_string_literal: true

require 'test_helper'

describe Users::SearchController do
  include Devise::Test::IntegrationHelpers

  describe '#index' do
    it 'ユーザーを名前で検索する' do
      sign_in users(:hanako)

      get users_search_index_path(keyword: '太郎')

      assert_response :success
      assert_includes response.body, users(:taro).name
      assert_not_includes response.body, users(:jiro).name
    end
  end
end
