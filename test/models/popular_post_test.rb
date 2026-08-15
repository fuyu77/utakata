# frozen_string_literal: true

require 'test_helper'

class PopularPostTest < ActiveSupport::TestCase
  setup do
    PopularPost.delete_all
    Follow.delete_all
  end

  test '直近24時間のいいね数で順位を更新し作者ごとに一首だけ選ぶ' do
    now = Time.zone.local(2026, 8, 15, 12)
    alice_first = posts(:alice_first)
    alice_second = posts(:alice_second)
    bob_first = posts(:bob_first)
    alice_first.update_columns(created_at: now - 3.days) # rubocop:disable Rails/SkipsModelValidations
    alice_second.update_columns(created_at: now - 2.days) # rubocop:disable Rails/SkipsModelValidations
    bob_first.update_columns(created_at: now - 1.day) # rubocop:disable Rails/SkipsModelValidations

    create_follow!(follower: users(:bob), followable: alice_first, created_at: now - 1.hour)
    create_follow!(follower: users(:carol), followable: alice_first, created_at: now - 2.hours)
    create_follow!(follower: users(:dave), followable: alice_second, created_at: now - 1.hour)
    create_follow!(follower: users(:alice), followable: bob_first, created_at: now - 1.hour)
    create_follow!(follower: users(:carol), followable: bob_first, created_at: now - 2.hours)
    create_follow!(follower: users(:dave), followable: bob_first, created_at: now - 3.hours)

    PopularPost.refresh!(now:)

    assert_equal [bob_first.id, alice_first.id], PopularPost.order(:position).pluck(:post_id)
  end

  test '24時間より前のいいねと7日以内のお返しいいねを集計しない' do
    now = Time.zone.local(2026, 8, 15, 12)
    alice_post = posts(:alice_first)
    bob_post = posts(:bob_first)
    carol_post = posts(:carol_first)

    create_follow!(follower: users(:bob), followable: alice_post, created_at: now - 1.hour)
    create_follow!(follower: users(:alice), followable: bob_post, created_at: now - 2.days)
    create_follow!(follower: users(:dave), followable: carol_post, created_at: now - 25.hours)

    PopularPost.refresh!(now:)

    assert_empty PopularPost.all
  end

  test '既存の順位を新しい集計結果に置き換える' do
    now = Time.zone.local(2026, 8, 15, 12)
    old_post = posts(:alice_first)
    new_post = posts(:bob_first)
    PopularPost.create!(post: old_post, position: 1)
    create_follow!(follower: users(:carol), followable: new_post, created_at: now - 1.hour)

    PopularPost.refresh!(now:)

    assert_equal [[new_post.id, 1]], PopularPost.pluck(:post_id, :position)
  end

  private

  def create_follow!(follower:, followable:, created_at: Time.current)
    Follow.create!(follower:, followable:, user_id: followable.user_id, created_at:)
  end
end
