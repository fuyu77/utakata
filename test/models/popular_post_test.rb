# frozen_string_literal: true

require 'test_helper'

describe PopularPost do
  before do
    PopularPost.delete_all
    Follow.delete_all
  end

  describe '.refresh!' do
    it '直近24時間のいいね数で順位を更新し作者ごとに一首だけ選ぶ' do
      now = Time.zone.local(2026, 8, 15, 12)
      hanako_first = posts(:hanako_first)
      hanako_second = posts(:hanako_second)
      taro_first = posts(:taro_first)
      hanako_first.update_columns(created_at: now - 3.days) # rubocop:disable Rails/SkipsModelValidations
      hanako_second.update_columns(created_at: now - 2.days) # rubocop:disable Rails/SkipsModelValidations
      taro_first.update_columns(created_at: now - 1.day) # rubocop:disable Rails/SkipsModelValidations

      create_follow!(follower: users(:taro), followable: hanako_first, created_at: now - 1.hour)
      create_follow!(follower: users(:jiro), followable: hanako_first, created_at: now - 2.hours)
      create_follow!(follower: users(:saburo), followable: hanako_second, created_at: now - 1.hour)
      create_follow!(follower: users(:hanako), followable: taro_first, created_at: now - 1.hour)
      create_follow!(follower: users(:jiro), followable: taro_first, created_at: now - 2.hours)
      create_follow!(follower: users(:saburo), followable: taro_first, created_at: now - 3.hours)

      PopularPost.refresh!(now:)

      assert_equal [taro_first.id, hanako_first.id], PopularPost.order(:position).pluck(:post_id)
    end

    it '24時間より前のいいねと7日以内のお返しいいねを集計しない' do
      now = Time.zone.local(2026, 8, 15, 12)
      hanako_post = posts(:hanako_first)
      taro_post = posts(:taro_first)
      jiro_post = posts(:jiro_first)

      create_follow!(follower: users(:taro), followable: hanako_post, created_at: now - 1.hour)
      create_follow!(follower: users(:hanako), followable: taro_post, created_at: now - 2.days)
      create_follow!(follower: users(:saburo), followable: jiro_post, created_at: now - 25.hours)

      PopularPost.refresh!(now:)

      assert_empty PopularPost.all
    end

    it '既存の順位を新しい集計結果に置き換える' do
      now = Time.zone.local(2026, 8, 15, 12)
      old_post = posts(:hanako_first)
      new_post = posts(:taro_first)
      PopularPost.create!(post: old_post, position: 1)
      create_follow!(follower: users(:jiro), followable: new_post, created_at: now - 1.hour)

      PopularPost.refresh!(now:)

      assert_equal [[new_post.id, 1]], PopularPost.pluck(:post_id, :position)
    end
  end

  private

  def create_follow!(follower:, followable:, created_at: Time.current)
    Follow.create!(follower:, followable:, user_id: followable.user_id, created_at:)
  end
end
