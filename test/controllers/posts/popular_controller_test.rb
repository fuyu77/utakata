# frozen_string_literal: true

require 'test_helper'

describe Posts::PopularController do
  describe '#index' do
    it '人気順に投稿を表示する' do
      PopularPost.create!(post: posts(:taro_first), position: 1)
      PopularPost.create!(post: posts(:hanako_first), position: 2)

      get posts_popular_index_path

      assert_response :success
      assert_operator response.body.index(posts(:taro_first).tanka), :<,
                      response.body.index(posts(:hanako_first).tanka)
    end
  end
end
