# frozen_string_literal: true

class FavoritesController < ApplicationController
  def create
    @size = params[:size]
    @post = Post.find(params[:follow])
    return if current_user.following?(@post)

    current_user.follow(@post)
  end

  def destroy
    @size = params[:size]
    @post = Post.find(params[:id])
    current_user.stop_following(@post)
  end
end
