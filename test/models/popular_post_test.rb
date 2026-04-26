# frozen_string_literal: true

require 'test_helper'

class PopularPostTest < ActiveSupport::TestCase
  test '.refresh! bulk inserts ranked posts' do
    now = Time.zone.local(2026, 4, 26, 12, 0, 0)
    posts = Array.new(3) { |index| create_post!(index) }
    ranked_posts = posts.map { |post| Struct.new(:post_id).new(post.id) }

    stub_ranked_posts(ranked_posts) do
      PopularPost.refresh!(now:)
    end

    assert_equal posts.map(&:id), PopularPost.order(:position).pluck(:post_id)
    assert_equal [1, 2, 3], PopularPost.order(:position).pluck(:position)
    assert_equal [now], PopularPost.distinct.pluck(:created_at)
    assert_equal [now], PopularPost.distinct.pluck(:updated_at)
  end

  test '.refresh! clears existing rows when there are no ranked posts' do
    post = create_post!(0)
    PopularPost.create!(post:, position: 1)

    stub_ranked_posts([]) do
      PopularPost.refresh!
    end

    assert_empty PopularPost.all
  end

  private

  def stub_ranked_posts(ranked_posts)
    singleton_class = class << PopularPost; self; end
    original_method = singleton_class.instance_method(:ranked_posts)

    singleton_class.define_method(:ranked_posts) { |**| ranked_posts }
    singleton_class.send(:private, :ranked_posts)

    yield
  ensure
    singleton_class.define_method(:ranked_posts, original_method)
    singleton_class.send(:private, :ranked_posts)
  end

  def create_post!(index)
    user = User.create!(
      email: "popular-post-#{index}@example.com",
      password: 'password',
      name: "popular-post-#{index}",
      confirmed_at: Time.current
    )

    Post.create!(
      user:,
      tanka: "あいうえお#{index}",
      published_at: Time.current
    )
  end
end
