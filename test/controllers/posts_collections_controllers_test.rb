# frozen_string_literal: true

require 'test_helper'

class PostsCollectionsControllersTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

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

  describe Posts::MySearchController do
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

  describe Posts::SearchController do
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
end
