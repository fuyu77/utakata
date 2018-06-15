class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:timeline, :favorite, :notifications]

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order('created_at DESC').page(params[:page])
  end
  
  def search
    @search = params[:search]
    @users = User.search(params[:search]).order('created_at DESC').page(params[:page])
  end

  def follow
    @user = User.find(params[:id])
    @users = @user.following_by_type('User').page(params[:page])
  end

  def follower
    @user = User.find(params[:id])
    @users = @user.followers_by_type('User').page(params[:page])
  end

  def timeline
    @users = current_user.following_by_type('User').ids + [params[:id]]
    @posts = Post.where(user_id: @users).order('created_at DESC').page(params[:page])
  end

  def favorite
    @posts = current_user.following_by_type('Post').page(params[:page])
  end

  def notifications
    @notifications = Follow.where(user_id: params[:id]).order('created_at DESC').page(params[:page])
    @notifications.each do |notification|
      notification.update(read: true)
    end
  end
end
