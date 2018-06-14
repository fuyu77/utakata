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

  def self.order_by_ids(ids)
    order_by = ["CASE"]
    ids.each_with_index do |id, index|
      order_by << "WHEN id='#{id}' THEN #{index}"
    end
    order_by << "END"
    order(order_by.join(" "))
  end
end
