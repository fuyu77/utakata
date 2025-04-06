# frozen_string_literal: true

class Post < ApplicationRecord
  include SqlQueries

  acts_as_followable

  belongs_to :user

  validates :tanka, presence: true, uniqueness: true, length: { minimum: 5, maximum: 1000 }
  validates :published_at, presence: true

  def input_tanka
    tanka.gsub('<rp>（</rp><rt>', '<rt>')
         .gsub('</rt><rp>）</rp>', '</rt>')
         .gsub('<span class="tate">', '<tate>')
         .gsub('</span>', '</tate>')
  end

  def tanka_text
    ApplicationController.helpers.strip_tags(tanka)
  end

  def twitter_share_url(url)
    uri_encoded_tanka = URI.encode_www_form_component(tanka_text)
    uri_encoded_user = URI.encode_www_form_component(user.name)
    "https://x.com/intent/tweet?url=#{url}&text=#{uri_encoded_tanka}%0a／#{uri_encoded_user}%0a"
  end

  def likes_count
    followings.length
  end
end
