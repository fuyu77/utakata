# frozen_string_literal: true

class FavoritesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    return if current_user.following?(@post)

    current_user.follow(@post)
    respond_to { |format| format.turbo_stream }
  end

  def destroy
    @post = Post.find(params[:id])
    current_user.stop_following(@post)
    respond_to { |format| format.turbo_stream }
  end
end
