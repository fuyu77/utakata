# frozen_string_literal: true

require 'test_helper'

class PopularPostTest < ActiveSupport::TestCase
  include ActiveSupport::Testing::TimeHelpers

  test 'rebuild creates popular posts ordered by eligible favorites count' do
    travel_to Time.zone.local(2026, 4, 25, 12, 0, 0) do
      first_post = create_post(created_at: 3.days.ago)
      second_post = create_post(created_at: 2.days.ago)

      2.times { |index| create_favorite(post: first_post, liker: create_user("first_liker_#{index}")) }
      3.times { |index| create_favorite(post: second_post, liker: create_user("second_liker_#{index}")) }

      PopularPost.rebuild!

      assert_equal [second_post.id, first_post.id], PopularPost.order(:position).pluck(:post_id)
      assert_equal [1, 2], PopularPost.order(:position).pluck(:position)
    end
  end

  test 'rebuild ignores favorites from users liked by the post author in the last seven days' do
    travel_to Time.zone.local(2026, 4, 25, 12, 0, 0) do
      author = create_user('author')
      reciprocal_liker = create_user('reciprocal_liker')
      eligible_liker = create_user('eligible_liker')
      reciprocal_liker_post = create_post(user: reciprocal_liker)
      popular_candidate = create_post(user: author)

      create_favorite(post: reciprocal_liker_post, liker: author, created_at: 6.days.ago)
      create_favorite(post: popular_candidate, liker: reciprocal_liker)
      create_favorite(post: popular_candidate, liker: eligible_liker)

      PopularPost.rebuild!

      assert_equal [popular_candidate.id], PopularPost.order(:position).pluck(:post_id)
      assert_equal [1], PopularPost.order(:position).pluck(:position)
    end
  end

  test 'rebuild replaces existing popular posts and limits records to thirty' do
    travel_to Time.zone.local(2026, 4, 25, 12, 0, 0) do
      old_popular_post = create_post(tanka: '古い人気データ')
      PopularPost.create!(post: old_popular_post, position: 1)

      31.times do |index|
        post = create_post(tanka: "人気候補#{index}", created_at: index.days.ago)
        create_favorite(post:, liker: create_user("liker_#{index}"))
      end

      PopularPost.rebuild!

      assert_equal 30, PopularPost.count
      assert_not_includes PopularPost.pluck(:post_id), old_popular_post.id
    end
  end

  private

  def create_user(name)
    User.create!(
      name:,
      email: "#{name}@example.com",
      password: 'password',
      confirmed_at: Time.current
    )
  end

  def create_post(
    user: create_user("user_#{SecureRandom.hex(4)}"),
    tanka: SecureRandom.hex(20),
    created_at: Time.current
  )
    Post.create!(
      user:,
      tanka:,
      published_at: created_at,
      created_at:,
      updated_at: created_at
    )
  end

  def create_favorite(post:, liker:, created_at: Time.current)
    Follow.create!(
      followable: post,
      follower: liker,
      user_id: liker.id,
      created_at:,
      updated_at: created_at
    )
  end
end
