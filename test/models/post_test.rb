# frozen_string_literal: true

require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test '編集用の短歌記法に変換する' do
    post = posts(:hanako_first)
    post.tanka = '泡<rp>（</rp><rt>うた</rt><rp>）</rp><span class="tate">縦</span>'

    assert_equal '泡<rt>うた</rt><tate>縦</tate>', post.input_tanka
  end

  test 'HTMLタグを除いた短歌本文を返す' do
    post = posts(:hanako_first)
    post.tanka = '泡<ruby>沫<rt>うたかた</rt></ruby><br>の歌'

    assert_equal '泡沫うたかたの歌', post.tanka_text
  end

  test '短歌本文と作者名を含むX共有URLを返す' do
    post = posts(:hanako_first)
    post.tanka = '泡沫の歌'

    assert_equal(
      'https://x.com/intent/tweet?url=https://example.com/posts/1&text=%E6%B3%A1%E6%B2%AB%E3%81%AE%E6%AD%8C%0a／%E5%B1%B1%E7%94%B0%E8%8A%B1%E5%AD%90%0a',
      post.twitter_share_url('https://example.com/posts/1')
    )
  end

  test 'いいね数を返す' do
    post = posts(:hanako_first)
    create_follow!(follower: users(:taro), followable: post)
    create_follow!(follower: users(:jiro), followable: post)

    assert_equal 2, post.likes_count
  end

  private

  def create_follow!(follower:, followable:)
    Follow.create!(follower:, followable:, user_id: followable.user_id)
  end
end
