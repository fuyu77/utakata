# frozen_string_literal: true

class User < ApplicationRecord
  include SqlQueries

  acts_as_followable
  acts_as_follower

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :omniauthable

  has_many :posts, dependent: :destroy
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
  validates :profile, length: { maximum: 1000 }
  validates :twitter_id, length: { maximum: 16 }

  class << self
    def find_or_create_by_twitter_oauth(auth)
      user = User.find_by(provider: auth.provider, uid: auth.uid)
      user ||= User.create(
        name: auth.info.name,
        provider: auth.provider,
        uid: auth.uid,
        email: "#{SecureRandom.uuid}@twitter.com",
        password: Devise.friendly_token[0, 20],
        twitter_id: auth.info.nickname
      )
      user.remember_me = true
      user
    end
  end

  def update_without_current_password(params, *options)
    params.delete(:current_password)

    result = update(params, *options)
    clean_up_passwords
    result
  end

  def today_posts_count
    posts.where('created_at >= ?', Time.zone.now.midnight).count
  end
end
