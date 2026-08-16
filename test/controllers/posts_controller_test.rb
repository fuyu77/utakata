# frozen_string_literal: true

require 'test_helper'

describe PostsController do
  include Devise::Test::IntegrationHelpers

  describe '#index' do
    it '投稿一覧を表示する' do
      get posts_path

      assert_response :success
      assert_includes response.body, posts(:hanako_first).tanka
    end

    it 'Hotwire Native用フィードタブでは新着を選択状態にする' do
      get posts_path

      assert_select 'nav.native-feed-tabs' do
        assert_select 'a[aria-current="page"]', text: '新着'
        assert_select 'a', text: '人気'
        assert_select 'a', text: 'フォロー中'
      end
      assert_select '.toggle-button-group.web-only', count: 2
    end
  end

  describe '#show' do
    it '投稿を表示する' do
      get post_path(posts(:hanako_first))

      assert_response :success
      assert_includes response.body, posts(:hanako_first).tanka
      assert_includes response.body, users(:hanako).name
    end
  end

  describe '#new' do
    it '未ログインの場合はログイン画面へ遷移する' do
      get new_post_path

      assert_redirected_to new_user_session_path
    end

    it '新規投稿画面を表示する' do
      sign_in users(:hanako)

      get new_post_path

      assert_response :success
    end
  end

  describe '#edit' do
    it '自分の投稿の編集画面を表示する' do
      sign_in users(:hanako)

      get edit_post_path(posts(:hanako_first))

      assert_response :success
    end

    it '他ユーザーの投稿の場合はトップページへ遷移する' do
      sign_in users(:hanako)

      get edit_post_path(posts(:taro_first))

      assert_redirected_to root_path
    end
  end

  describe '#create' do
    it '装飾記法を変換して投稿する' do
      user = users(:hanako)
      sign_in user

      assert_difference 'user.posts.count', 1 do
        post posts_path, params: { post: { tanka: '泡<rt>うた</rt><tate>縦書き</tate>' } }
      end

      assert_redirected_to posts_path
      assert_equal '泡<rp>（</rp><rt>うた</rt><rp>）</rp><span class="tate">縦書き</span>', user.posts.last.tanka
    end

    it '不正な投稿の場合はエラーを表示する' do
      sign_in users(:hanako)

      assert_no_difference 'Post.count' do
        post posts_path, params: { post: { tanka: '' } }, as: :turbo_stream
      end

      assert_response :success
      assert_includes response.body, 'alert'
    end
  end

  describe '#update' do
    it '投稿を更新する' do
      post_record = posts(:hanako_first)
      sign_in users(:hanako)

      patch post_path(post_record), params: { post: { tanka: '更新後の短歌です' } }

      assert_redirected_to post_path(post_record)
      assert_equal '更新後の短歌です', post_record.reload.tanka
    end
  end

  describe '#destroy' do
    it '投稿を削除する' do
      sign_in users(:hanako)

      assert_difference 'Post.count', -1 do
        delete post_path(posts(:hanako_first))
      end

      assert_redirected_to user_path(users(:hanako)), status: :see_other
    end
  end
end
