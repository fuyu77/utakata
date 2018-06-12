class Post < ApplicationRecord
  acts_as_followable
  belongs_to :user, inverse_of: :posts
  validates :user_id, presence: true
  validates :tanka, presence: true, uniqueness: true, length: { minimum: 5, maximum: 62 }

  def self.search(search)
    if search
      where(['tanka LIKE ?', "%#{search}%"])
    else
      all
    end
  end
end
