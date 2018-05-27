class Post < ApplicationRecord
  belongs_to :user, inverse_of: :posts

  validates :user_id, presence: true
  validates :tanka, presence: true, length: { maximum: 62 }
end
