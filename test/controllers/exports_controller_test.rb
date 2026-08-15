# frozen_string_literal: true

require 'test_helper'

class ExportsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  describe '#index' do
    it '未ログインの場合はログイン画面へ遷移する' do
      get exports_path

      assert_redirected_to new_user_session_path
    end

    it 'ログインユーザーの投稿をCSVで出力する' do
      sign_in users(:hanako)

      get exports_path(format: :csv)

      assert_response :success
      assert_equal 'text/csv', response.media_type
      csv = CSV.parse(response.body.delete_prefix("\uFEFF"), headers: true)

      assert_equal [posts(:hanako_first).tanka, posts(:hanako_second).tanka].sort,
                   csv['短歌'].sort
    end
  end
end
