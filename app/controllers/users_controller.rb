class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:timeline, :favorite, :notifications]

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order('created_at DESC').page(params[:page])
    @count = @posts.count
  end
  
  def search
    @search = params[:search]
    @users = User.search(params[:search]).order('created_at DESC').page(params[:page])
  end

  def follow
    @user = User.find(params[:id])
    follows = Follow.where(followable_type: 'User', follower_id: @user.id).order('created_at DESC').pluck(:followable_id)
    if follows.present?
      @users = User.where(id: follows).order_by_ids(follows).page(params[:page])
    else
      @users = User.none.page(params[:page])
    end
  end

  def follower
    @user = User.find(params[:id])
    followers = Follow.where(followable_type: 'User', followable_id: @user.id).order('created_at DESC').pluck(:follower_id)
    if followers.present?
      @users = User.where(id: followers).order_by_ids(followers).page(params[:page])
    else
      @users = User.none.page(params[:page])
    end
  end

  def timeline
    @users = current_user.following_by_type('User').ids + [current_user.id]
    @posts = Post.where(user_id: @users).order('created_at DESC').page(params[:page])
  end

  def favorite
    favorites = Follow.where(followable_type: 'Post', follower_id: current_user.id).order('created_at DESC').pluck(:followable_id)
    if favorites.present?
      @posts = Post.where(id: favorites).order_by_ids(favorites).page(params[:page])
    else
      @posts = Post.none.page(params[:page])
    end
  end

  def notifications
    @notifications = Follow.where(user_id: current_user.id).order('created_at DESC').page(params[:page])
    @notifications.each do |notification|
      notification.update(read: true)
    end
  end
end
