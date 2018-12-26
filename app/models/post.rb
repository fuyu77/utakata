# frozen_string_literal: true

class Post < ApplicationRecord
  acts_as_followable
  belongs_to :user
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

  def self.add_html_tag(text)
    text = ApplicationController.helpers.sanitize(text, tags: %w[ruby rt tate], attributes: %w[])
    text.gsub('<rt>', '<rp>（</rp><rt>')
        .gsub('</rt>', '</rt><rp>）</rp>')
        .gsub('<tate>', '<span class="tate">')
        .gsub('</tate>', '</span>')
  end

  def self.remove_html_tag(text)
    text.gsub('<rp>（</rp><rt>', '<rt>')
        .gsub('</rt><rp>）</rp>', '</rt>')
        .gsub('<span class="tate">', '<tate>')
        .gsub('</span>', '</tate>')
  end
end
