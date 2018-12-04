# frozen_string_literal: true

class Chapter < ApplicationRecord
  acts_as_followable
  acts_as_follower
  belongs_to :user
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 1000 }
end
