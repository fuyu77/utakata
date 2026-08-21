# frozen_string_literal: true

SEED_EMAIL_DOMAIN = 'seed.utakata.local'
SEED_PASSWORD = 'password'

USERS = [
  {
    email: "demo@#{SEED_EMAIL_DOMAIN}",
    name: 'うたかた',
    profile: 'モバイルアプリの画面確認に使うメインユーザーです。',
    twitter_id: 'utakata_demo',
    avatar: 'utakata.svg'
  },
  {
    email: "akari@#{SEED_EMAIL_DOMAIN}",
    name: 'あかり',
    profile: '朝の光と季節の移ろいを詠んでいます。',
    twitter_id: 'akari_tanka',
    avatar: 'akari.svg'
  },
  {
    email: "sora@#{SEED_EMAIL_DOMAIN}",
    name: 'そら',
    profile: '空や風を題材にした短歌が好きです。',
    twitter_id: 'sora_tanka',
    avatar: 'sora.svg'
  },
  {
    email: "midori@#{SEED_EMAIL_DOMAIN}",
    name: 'みどり',
    profile: '草花の小さな変化を書き留めています。',
    twitter_id: 'midori_tanka',
    avatar: 'midori.svg'
  },
  {
    email: "nagi@#{SEED_EMAIL_DOMAIN}",
    name: '凪',
    profile: '海辺の景色と言葉を集めています。',
    twitter_id: 'nagi_tanka',
    avatar: 'nagi.svg'
  }
].freeze

POSTS = [
  {
    author: 'demo',
    tanka: '朝露を　ほどいてひらく　白い花　今日という日の　余白を照らす',
    published_days_ago: 0
  },
  {
    author: 'demo',
    tanka: '帰り道　ポケットのなか　鳴る鍵に　小さな家の　灯りをおもう',
    published_days_ago: 3
  },
  {
    author: 'akari',
    tanka: 'カーテンを　透かした光　頬に受け　まだ名も知らぬ　一日を編む',
    published_days_ago: 0
  },
  {
    author: 'akari',
    tanka: '雨あがり　傘をたたんで　見上げれば　雲の切れ間に　夏がほどける',
    published_days_ago: 5
  },
  {
    author: 'sora',
    tanka: '風の名を　知らないままで　立つ丘に　青の深さを　教わっている',
    published_days_ago: 1
  },
  {
    author: 'sora',
    tanka: '夕焼けを　分け合うように　窓ひらく　遠い街にも　同じ色降る',
    published_days_ago: 8
  },
  {
    author: 'midori',
    tanka: '新しい　葉を見つけたと　呼ぶ声に　ベランダまでの　春が近づく',
    published_days_ago: 2
  },
  {
    author: 'midori',
    tanka: '花びらを　栞のように　挟む午後　読みかけの本　風にほどける',
    published_days_ago: 13
  },
  {
    author: 'nagi',
    tanka: '波音の　途切れる場所で　待ち合わせ　言葉より先に　夕凪が来る',
    published_days_ago: 1
  },
  {
    author: 'nagi',
    tanka: '砂浜に　ふたつの影を　置いてきた　潮が満ちても　消えない記憶',
    published_days_ago: 21
  }
].freeze

USER_FOLLOWS = [
  %w[demo akari],
  %w[demo sora],
  %w[akari demo],
  %w[midori demo],
  %w[nagi akari],
  %w[sora midori]
].freeze

POST_LIKES = [
  ['demo', 2],
  ['demo', 4],
  ['demo', 6],
  ['akari', 0],
  ['akari', 4],
  ['sora', 0],
  ['sora', 2],
  ['sora', 8],
  ['midori', 0],
  ['midori', 2],
  ['midori', 4],
  ['nagi', 2],
  ['nagi', 4],
  ['nagi', 6]
].freeze

now = Time.current.change(usec: 0)
seed_users = User.where('email LIKE ?', "%@#{SEED_EMAIL_DOMAIN}")
seed_user_ids = seed_users.ids
seed_post_ids = Post.where(user_id: seed_user_ids).ids

ApplicationRecord.transaction do
  unless seed_user_ids.empty?
    Follow.where(follower_type: 'User', follower_id: seed_user_ids)
          .or(Follow.where(followable_type: 'Post', followable_id: seed_post_ids))
          .delete_all
    PopularPost.where(post_id: seed_post_ids).delete_all
    seed_users.destroy_all
  end

  encrypted_password = Devise::Encryptor.digest(User, SEED_PASSWORD)
  User.insert_all!(
    USERS.map do |user|
      user.except(:avatar).merge(
        encrypted_password:,
        confirmed_at: now,
        created_at: now,
        updated_at: now
      )
    end
  )

  seed_emails = USERS.map { |user| user.fetch(:email) }
  users_by_key = User.where(email: seed_emails).index_by { |user| user.email.split('@').first }
  avatar_directory = Rails.root.join('db/seeds/avatars')
  USERS.each do |user_attributes|
    File.open(avatar_directory.join(user_attributes.fetch(:avatar))) do |avatar|
      users_by_key.fetch(user_attributes.fetch(:email).split('@').first).update!(avatar:)
    end
  end

  Post.insert_all!(
    POSTS.map do |post|
      published_at = now - post.fetch(:published_days_ago).days
      {
        user_id: users_by_key.fetch(post.fetch(:author)).id,
        tanka: post.fetch(:tanka),
        published_at:,
        created_at: published_at,
        updated_at: published_at
      }
    end
  )

  seed_tankas = POSTS.map { |post| post.fetch(:tanka) }
  posts_by_tanka = Post.where(tanka: seed_tankas).index_by(&:tanka)
  follow_rows = USER_FOLLOWS.map.with_index do |(follower_key, followable_key), index|
    follower = users_by_key.fetch(follower_key)
    followable = users_by_key.fetch(followable_key)
    created_at = now - (index + 1).hours

    {
      follower_id: follower.id,
      follower_type: 'User',
      followable_id: followable.id,
      followable_type: 'User',
      user_id: followable.id,
      read: index.odd?,
      blocked: false,
      created_at:,
      updated_at: created_at
    }
  end

  follow_rows.concat(
    POST_LIKES.map.with_index do |(follower_key, post_index), index|
      follower = users_by_key.fetch(follower_key)
      post = posts_by_tanka.fetch(POSTS.fetch(post_index).fetch(:tanka))
      created_at = now - (index + 1).minutes

      {
        follower_id: follower.id,
        follower_type: 'User',
        followable_id: post.id,
        followable_type: 'Post',
        user_id: post.user_id,
        read: index.odd?,
        blocked: false,
        created_at:,
        updated_at: created_at
      }
    end
  )
  Follow.insert_all!(follow_rows)

  PopularPost.refresh!(now:)
end

Rails.logger.info <<~MESSAGE
  Development seed data was loaded.
  Login: demo@#{SEED_EMAIL_DOMAIN}
  Password: #{SEED_PASSWORD}
MESSAGE
