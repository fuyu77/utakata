# frozen_string_literal: true

class Api::PostsController < ApplicationController
  def index
    user = User.find(params[:user_id])
    posts = user.posts.includes(:followings).order(id: :desc)
    render json: posts.as_json(only: %i[id published_at], methods: %i[tanka_text likes_count])
  end
end
