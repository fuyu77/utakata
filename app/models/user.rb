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
         :confirmable

  has_many :posts, dependent: :destroy
  has_attached_file :avatar,
                    styles: { original: '225x225#', medium: '105x105#', small: '60x60#' },
                    convert_options: { all: '-strip' },
                    default_url: '//utakata.s3.amazonaws.com/:style/utakata.png'

  validates_attachment_content_type :avatar, content_type: %r{\Aimage/.*\z}
  validates :name, presence: true, length: { maximum: 50 }
  validates :profile, length: { maximum: 1000 }
  validates :twitter_id, length: { maximum: 16 }

  def update_without_current_password(params, *)
    params.delete(:current_password)

    result = update(params, *)
    clean_up_passwords
    result
  end

  def today_posts_count
    posts.where(created_at: Time.zone.now.midnight..).count
  end
end
