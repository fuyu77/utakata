# frozen_string_literal: true

class FavoritesController < ApplicationController
  before_action :authenticate_user!, only: %i[index]

  def index
    post_ids = Follow.where(followable_type: 'Post', follower_id: current_user.id)
                     .order(id: :desc)
                     .pluck(:followable_id)
    @posts = Post.includes(:user, :followings).where(id: post_ids).order_by_ids(post_ids).page(params[:page])
  end

  def create
    @post = Post.find(params[:post_id])
    return if current_user.following?(@post)

    current_user.follow(@post)
    respond_to { |format| format.turbo_stream }
  end

  def destroy
    @post = Post.find(params[:post_id])
    current_user.stop_following(@post)
    respond_to { |format| format.turbo_stream }
  end
end
