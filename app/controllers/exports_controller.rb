# frozen_string_literal: true

class ExportsController < ApplicationController
  before_action :authenticate_user!, only: %i[index]

  def index
    posts = current_user.posts.includes(:followings).order('published_at DESC')
    csv_data = CSV.generate do |csv|
      headers = %w[短歌 いいね数 投稿日時]
      csv << headers
      posts.each do |post|
        values = [
          post.tanka_text,
          post.followings.length,
          post.published_at.strftime('%Y-%m-%dT%H:%M:%S')
        ]
        csv << values
      end
    end
    respond_to do |format|
      format.html
      format.csv { send_data csv_data, filename: '投稿短歌.csv' }
    end
  end
end
