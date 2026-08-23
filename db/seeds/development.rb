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
  ['demo', '朝露をほどいてひらく白い花今日という日の余白を照らす', 0],
  ['demo', '帰り道ポケットのなか鳴る鍵に小さな家の灯りをおもう', 3],
  ['akari', 'カーテンを透かした光頬に受けまだ名も知らぬ一日を編む', 0],
  ['akari', '雨あがり傘をたたんで見上げれば雲の切れ間に夏がほどける', 5],
  ['sora', '風の名を知らないままで立つ丘に青の深さを教わっている', 1],
  ['sora', '夕焼けを分け合うように窓ひらく遠い街にも同じ色降る', 8],
  ['midori', '新しい葉を見つけたと呼ぶ声にベランダまでの春が近づく', 2],
  ['midori', '花びらを栞のように挟む午後読みかけの本風にほどける', 13],
  ['nagi', '波音の途切れる場所で待ち合わせ言葉より先に夕凪が来る', 1],
  ['nagi', '砂浜にふたつの影を置いてきた潮が満ちても消えない記憶', 21],
  ['demo', '窓際の冷めゆく珈琲手に包み遠くの雨を静かに聞いた', 4],
  ['demo', '改札を抜ければ風が名を呼んで夕暮れ色の街へと帰る', 7],
  ['demo', '眠る前消した画面に顔映り今日の言葉をひとつほどいた', 10],
  ['demo', '朝焼けの電車は川を渡りゆき知らない町の暮らしを照らす', 14],
  ['demo', '靴ひもを結び直した交差点青信号に背中を押される', 18],
  ['akari', '目覚ましの少し手前で目を覚まし鳥の声から朝を受け取る', 2],
  ['akari', '洗いたてシャツの白さを風が撫で小さな雲が屋根を越えゆく', 6],
  ['akari', '金色のスプーン沈むスープには昨日のことを許す温もり', 9],
  ['akari', '街路樹の影を踏みつつ歩く午後光の粒が鞄に積もる', 15],
  ['akari', '遠雷を数えるうちに雨が来て窓辺の夏を静かに閉じる', 22],
  ['sora', '飛行機の細い軌跡を追いかけて言えない願い空へ預ける', 3],
  ['sora', '青空に洗濯物が揺れていて暮らしの音も軽くなる朝', 7],
  ['sora', '屋上で風にほどける髪を押さえ街の向こうの海を想った', 11],
  ['sora', '月明かり雲の切れ間を渡りゆき眠れぬ部屋に道を描いた', 16],
  ['sora', '一羽だけ遅れて飛んだ鳥を見て急がなくてもいいと思える', 24],
  ['midori', '鉢植えの土に小さな芽を見つけ名前を呼べぬ春を見守る', 4],
  ['midori', '木漏れ日がページの上を歩くたび物語にも季節がめぐる', 8],
  ['midori', '落ち葉踏む乾いた音を連れ帰り玄関先に秋を置いてく', 12],
  ['midori', '朝露をまとった草の匂いから雨の記憶がそっと立ちのぼる', 17],
  ['midori', '冬枯れの枝に残った実の赤が曇り空へ小さく灯る', 25],
  ['nagi', '防波堤腰かけたまま日が暮れて波の数だけ言葉を忘れる', 5],
  ['nagi', '貝殻を耳にあてれば遠い日の夏のざわめき今も聞こえる', 9],
  ['nagi', '潮風に自転車のベル溶けてゆき岬の先へ午後が流れる', 13],
  ['nagi', '水平線夕日をゆっくり飲み込んで帰る時間を波が知らせる', 19],
  ['nagi', '夜の浜星を映した波しぶき足跡だけが明日へ続く', 28]
].map do |author, tanka, published_days_ago|
  { author:, tanka:, published_days_ago: }
end.freeze

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
