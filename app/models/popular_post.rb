# frozen_string_literal: true

class PopularPost < ApplicationRecord
  belongs_to :post

  validates :position, presence: true, uniqueness: true
  validates :post_id, uniqueness: true
  validates :favorites_count, presence: true
end
