class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order('created_at DESC').page(params[:page])
  end
  
  def search
    @search = params[:search]
    @users = User.search(params[:search]).order('created_at DESC').page(params[:page])
  end
end
