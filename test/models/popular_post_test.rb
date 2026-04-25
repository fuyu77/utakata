# frozen_string_literal: true

require 'test_helper'

class PopularPostTest < ActiveSupport::TestCase
  test 'refresh creates popular posts ordered by recent likes' do
    now = Time.zone.local(2026, 4, 25, 12)
    first_author = create_user('first_author')
    second_author = create_user('second_author')
    first_post = create_post(first_author, 'first popular post')
    second_post = create_post(second_author, 'second popular post')

    3.times { |index| create_favorite(create_user("first_liker_#{index}"), first_post, now - 2.hours) }
    2.times { |index| create_favorite(create_user("second_liker_#{index}"), second_post, now - 2.hours) }

    PopularPost.refresh!(now:)

    assert_equal [first_post.id, second_post.id], PopularPost.order(:position).pluck(:post_id)
  end

  test 'refresh does not create posts liked only by users liked by the post author in the last 7 days' do
    now = Time.zone.local(2026, 4, 25, 12)
    author = create_user('author')
    returned_liker = create_user('returned_liker')
    returned_liker_post = create_post(returned_liker, 'returned liker post')
    target_post = create_post(author, 'target post')

    create_favorite(author, returned_liker_post, now - 2.days)
    create_favorite(returned_liker, target_post, now - 1.hour)

    PopularPost.refresh!(now:)

    assert_not PopularPost.exists?(post: target_post)
  end

  test 'refresh keeps only one post per author' do
    now = Time.zone.local(2026, 4, 25, 12)
    author = create_user('same_author')
    popular_post = create_post(author, 'more liked post')
    less_popular_post = create_post(author, 'less liked post')

    2.times { |index| create_favorite(create_user("popular_liker_#{index}"), popular_post, now - 1.hour) }
    create_favorite(create_user('less_popular_liker'), less_popular_post, now - 1.hour)

    PopularPost.refresh!(now:)

    assert_equal [popular_post.id], PopularPost.pluck(:post_id)
  end

  test 'refresh replaces existing popular posts' do
    now = Time.zone.local(2026, 4, 25, 12)
    old_post = create_post(create_user('old_author'), 'old post')
    new_post = create_post(create_user('new_author'), 'new post')
    PopularPost.create!(post: old_post, position: 1)

    create_favorite(create_user('new_liker'), new_post, now - 1.hour)

    PopularPost.refresh!(now:)

    assert_equal [new_post.id], PopularPost.pluck(:post_id)
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

  def create_post(user, tanka)
    Post.create!(
      user:,
      tanka:,
      published_at: Time.current
    )
  end

  def create_favorite(user, post, created_at)
    Follow.create!(
      followable: post,
      follower: user,
      user_id: user.id,
      created_at:,
      updated_at: created_at
    )
  end
end
