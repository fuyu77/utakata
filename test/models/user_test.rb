# frozen_string_literal: true

require 'test_helper'

describe User do
  describe 'twitter_idのバリデーション' do
    it '英数字とアンダースコアの値を登録できる' do
      user = users(:hanako)

      user.twitter_id = 'utakata_tanka77'

      assert_predicate user, :valid?
    end

    it '先頭の@を除去して登録する' do
      user = users(:hanako)

      user.twitter_id = '@utakatanka'

      assert user.save
      assert_equal 'utakatanka', user.reload.twitter_id
    end

    it '保存済みの先頭に@がある値を不正と判定する' do
      user = users(:hanako)
      User.connection.execute(<<~SQL.squish)
        UPDATE users SET twitter_id = '@utakatanka' WHERE id = #{user.id}
      SQL

      assert_not user.reload.valid?
    end

    it '先頭に@が複数ある値を登録できない' do
      user = users(:hanako)

      user.twitter_id = '@@utakatanka'

      assert_not user.valid?
    end

    it '途中に@がある値を登録できない' do
      user = users(:hanako)

      user.twitter_id = 'utakata@tanka'

      assert_not user.valid?
    end

    it '末尾に@がある値を登録できない' do
      user = users(:hanako)

      user.twitter_id = 'utakatanka@'

      assert_not user.valid?
    end

    it '英数字とアンダースコア以外を含む値を登録できない' do
      user = users(:hanako)

      user.twitter_id = 'utakata-tanka'

      assert_not user.valid?
    end

    it '16文字の値を登録できない' do
      user = users(:hanako)

      user.twitter_id = 'utakata_tanka777'

      assert_not user.valid?
    end
  end

  describe '#update_without_current_password' do
    it '現在のパスワードなしでユーザー情報を更新する' do
      user = users(:hanako)
      params = { name: '更新後の名前', current_password: '誤ったパスワード' }

      assert user.update_without_current_password(params)
      assert_equal '更新後の名前', user.reload.name
      assert_not params.key?(:current_password)
    end
  end

  describe '#today_posts_count' do
    it '当日0時以降に作成した投稿数を返す' do
      user = users(:hanako)

      travel_to Time.zone.local(2026, 8, 15, 12) do
        posts(:hanako_first).update!(created_at: Time.current.beginning_of_day)
        posts(:hanako_second).update!(created_at: Time.current.beginning_of_day - 1.second)

        assert_equal 1, user.today_posts_count
      end
    end
  end
end
