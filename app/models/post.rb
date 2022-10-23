# frozen_string_literal: true

class Post < ApplicationRecord
  acts_as_followable
  belongs_to :user
  validates :tanka, presence: true, uniqueness: true, length: { minimum: 5, maximum: 1000 }
  validates :published_at, presence: true

  def self.search(search)
    where(['tanka LIKE ?', "%#{search}%"])
  end

  def self.order_by_ids(ids)
    order_by = ['CASE']
    ids.each_with_index do |id, index|
      order_by << "WHEN id='#{id}' THEN #{index}"
    end
    order_by << 'END'
    order(Arel.sql(order_by.join(' ')))
  end

  def tanka_text
    ApplicationController.helpers.strip_tags(tanka)
  end

  def input_tanka
    tanka.gsub('<rp>（</rp><rt>', '<rt>')
         .gsub('</rt><rp>）</rp>', '</rt>')
         .gsub('<span class="tate">', '<tate>')
         .gsub('</span>', '</tate>')
  end
end
