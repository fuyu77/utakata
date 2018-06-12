class UsersController < ApplicationController
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
end
