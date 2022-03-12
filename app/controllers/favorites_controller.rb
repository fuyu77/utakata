# frozen_string_literal: true

class FavoritesController < ApplicationController
  def create
    @post = Post.find(params[:follow])
    return if current_user.following?(@post)

    current_user.follow(@post)
    render turbo_stream: turbo_stream.replace(
      @post,
      partial: "favorites/unlike_#{params[:size]}",
      locals: { post: @post }
    )
  end

  def destroy
    @post = Post.find(params[:id])
    current_user.stop_following(@post)
    render turbo_stream: turbo_stream.replace(
      @post,
      partial: "favorites/like_#{params[:size]}",
      locals: { post: @post }
    )
  end
end
