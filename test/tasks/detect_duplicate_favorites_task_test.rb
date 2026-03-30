# frozen_string_literal: true

require 'test_helper'
require 'rake'

class DetectDuplicateFavoritesTaskTest < ActiveSupport::TestCase
  setup do
    Rake.application = Rake::Application.new
    Rails.application.load_tasks
    @task = Rake::Task['favorites:detect_duplicates']
  end

  teardown do
    @task.reenable
  end

  test '多重いいねの重複分だけ削除して1件残す' do
    user = create_user(name: 'duplicate-user')
    post = create_post(user:, tanka: '重複いいねを削除するテストです')
    first_follow = create_follow(user:, post:)
    second_follow = create_follow(user:, post:)
    third_follow = create_follow(user:, post:)

    @task.invoke

    remaining_follows = Follow.where(id: [first_follow.id, second_follow.id, third_follow.id]).order(:id)

    assert_equal [first_follow.id], remaining_follows.pluck(:id)
  end

  test '多重いいねがなければ既存のいいねを削除しない' do
    user = create_user(name: 'single-user')
    post = create_post(user:, tanka: '重複していないいいねの確認です')
    follow = create_follow(user:, post:)

    @task.invoke

    assert Follow.exists?(follow.id)
  end

  private

  def create_user(name:)
    User.create!(
      email: "#{name}-#{SecureRandom.hex(4)}@example.com",
      password: 'password',
      password_confirmation: 'password',
      name:,
      confirmed_at: Time.current
    )
  end

  def create_post(user:, tanka:)
    Post.create!(
      user:,
      tanka:,
      published_at: Time.current
    )
  end

  def create_follow(user:, post:)
    Follow.create!(
      follower: user,
      followable: post,
      user_id: post.user_id
    )
  end
end
