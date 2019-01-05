# frozen_string_literal: true

class Post < ApplicationRecord
  acts_as_followable
  belongs_to :user
  has_many :chapters, through: :chapter_posts
  has_many :chapter_posts, dependent: :destroy
  validates :user_id, presence: true
  validates :tanka, presence: true, uniqueness: true, length: { minimum: 5, maximum: 1000 }

  def self.search(search)
    where(['tanka LIKE ?', "%#{search}%"])
  end

  def self.order_by_ids(ids)
    order_by = ['CASE']
    ids.each_with_index do |id, index|
      order_by << "WHEN id='#{id}' THEN #{index}"
    end
    order_by << 'END'
    order(order_by.join(' '))
  end
end
