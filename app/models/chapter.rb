# frozen_string_literal: true

class Chapter < ApplicationRecord
  acts_as_followable
  acts_as_follower
  has_many :posts, through: :chapter_posts
  has_many :chapter_posts, dependent: :destroy
  belongs_to :user
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 1000 }
end
