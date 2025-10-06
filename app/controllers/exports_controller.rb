# frozen_string_literal: true

class ExportsController < ApplicationController
  before_action :authenticate_user!, only: %i[index]

  def index
    return if request.format.to_s == 'text/html'

    posts = current_user.posts.includes(:followings).order(published_at: :desc)
    csv_data = CSV.generate(+"\uFEFF") do |csv|
      headers = %w[短歌 投稿日時 いいね数]
      csv << headers
      posts.each do |post|
        values = [
          post.tanka_text,
          post.published_at.strftime('%Y-%m-%dT%H:%M:%S'),
          post.followings.length
        ]
        csv << values
      end
    end
    respond_to do |format|
      format.csv { send_data csv_data, filename: '投稿短歌.csv' }
    end
  end
end
