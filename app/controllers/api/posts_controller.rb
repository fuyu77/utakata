# frozen_string_literal: true

class Api::PostsController < ApplicationController
  def index
    user = User.find(params[:user_id])
    posts = user.posts.includes(:followings).order(id: :desc)
    render json: posts.as_json(only: %i[id tanka published_at], methods: [:likes_count])
  end
end
