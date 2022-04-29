# frozen_string_literal: true

class User < ApplicationRecord
  acts_as_followable
  acts_as_follower

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :omniauthable

  if Rails.env.production?
    has_attached_file :avatar,
                      styles: { original: '75x75#', medium: '35x35#', small: '20x20#' },
                      convert_options: { all: '-strip' },
                      default_url: 'https://utakata.s3.amazonaws.com/:style/utakata.png'
  else
    has_attached_file :avatar,
                      styles: { original: '75x75#', medium: '35x35#', small: '20x20#' },
                      convert_options: { all: '-strip' },
                      default_url: '/:style/utakata.png'
  end

  validates_attachment_content_type :avatar, content_type: %r{\Aimage/.*\z}

  validates :name, presence: true, length: { maximum: 50 }
  validates :name,
            format: {
              without: /[a-z]{10}/, message: '半角英小文字10字のアカウント名は不正登録対策のため、アカウント登録時には利用できません。登録後の変更は可能です。'
            },
            on: :create
  validates :profile, length: { maximum: 1000 }
  validates :twitter_id, length: { maximum: 16 }

  has_many :posts, dependent: :destroy

  def update_without_current_password(params, *options)
    params.delete(:current_password)

    result = update(params, *options)
    clean_up_passwords
    result
  end

  def self.search(search)
    where(['name LIKE ?', "%#{search}%"])
  end

  def self.order_by_ids(ids)
    order_by = ['CASE']
    ids.each_with_index do |id, index|
      order_by << "WHEN id='#{id}' THEN #{index}"
    end
    order_by << 'END'
    order(Arel.sql(order_by.join(' ')))
  end

  def self.find_for_twitter_oauth(auth, _signed_in_resource = nil)
    user = User.where(provider: auth.provider, uid: auth.uid).first
    user ||= User.create(
      name: auth.info.name,
      provider: auth.provider,
      uid: auth.uid,
      email: User.create_unique_email,
      password: Devise.friendly_token[0, 20],
      twitter_id: auth.info.nickname
    )
    user.remember_me = true
    user
  end

  # 通常サインアップ時のuid用、Twitter OAuth認証時のemail用にuuidな文字列を生成
  def self.create_unique_string
    SecureRandom.uuid
  end

  # Twitterではemailを取得できないので、適当に一意のemailを生成
  def self.create_unique_email
    "#{User.create_unique_string}@twitter.com"
  end
end
