# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test '現在のパスワードなしでユーザー情報を更新する' do
    user = users(:hanako)
    params = { name: '更新後の名前', current_password: '誤ったパスワード' }

    assert user.update_without_current_password(params)
    assert_equal '更新後の名前', user.reload.name
    assert_not params.key?(:current_password)
  end

  test '当日0時以降に作成した投稿数を返す' do
    user = users(:hanako)

    travel_to Time.zone.local(2026, 8, 15, 12) do
      posts(:hanako_first).update_columns(created_at: Time.current.beginning_of_day) # rubocop:disable Rails/SkipsModelValidations
      posts(:hanako_second).update_columns(created_at: Time.current.beginning_of_day - 1.second) # rubocop:disable Rails/SkipsModelValidations

      assert_equal 1, user.today_posts_count
    end
  end
end
