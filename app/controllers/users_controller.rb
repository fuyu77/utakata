# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[timeline likes notifications]

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order('created_at DESC').page(params[:page])
    @count = @user.posts.count
  end

  def index
    @users = User.all.order('created_at DESC').page(params[:page])
  end

  def search
    @search = params[:search]
    @users = User.search(params[:search]).order('created_at DESC').page(params[:page])
  end

  def followees
    @user = User.find(params[:id])
    follows = Follow.where(followable_type: 'User', follower_id: @user.id).order('created_at DESC').pluck(:followable_id)
    @users = follows.present? ?
      User.where(id: follows).order_by_ids(follows).page(params[:page]) :
      User.none.page(params[:page])
  end

  def followers
    @user = User.find(params[:id])
    followers = Follow.where(followable_type: 'User', followable_id: @user.id).order('created_at DESC').pluck(:follower_id)
    @users = followers.present? ?
      User.where(id: followers).order_by_ids(followers).page(params[:page]) :
      User.none.page(params[:page])
  end

  def timeline
    @users = current_user.following_by_type('User').ids + [current_user.id]
    @posts = Post.where(user_id: @users).order('created_at DESC').page(params[:page])
  end

  def likes
    favorites = Follow.where(followable_type: 'Post', follower_id: current_user.id).order('created_at DESC').pluck(:followable_id)
    @posts = favorites.present? ?
      Post.where(id: favorites).order_by_ids(favorites).page(params[:page]) :
      Post.none.page(params[:page])
  end

  def notifications
    @notifications = Follow.where(user_id: current_user.id).order('created_at DESC').page(params[:page])
    Follow.where(user_id: current_user.id, read: false).update_all(read: true)
  end
end
