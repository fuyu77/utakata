class User < ApplicationRecord
  acts_as_followable
  acts_as_follower
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  
  if Rails.env == 'production'
    has_attached_file :avatar, styles: { original: "75x75#", medium: "35x35#", small: "20x20#" }, default_url: "https://utakata.s3.amazonaws.com/:style/utakata.png"
  else
    has_attached_file :avatar, styles: { original: "75x75#", medium: "35x35#", small: "20x20#" }, default_url: "/:style/utakata.png"
  end
  
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  validates :name, presence: true, length: { maximum: 20 }
  validates :profile, length: { maximum: 140 }
  validates :twitter_id, length: { maximum: 16 }

  has_many :posts, inverse_of: :user, dependent: :destroy

  def update_without_current_password(params, *options)
    params.delete(:current_password)

    result = update(params, *options)
    clean_up_passwords
    result
  end

  def self.search(search)
    if search
      where(['name LIKE ?', "%#{search}%"])
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
