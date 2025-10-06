# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[index]

  def index
    @users = User.order(id: :desc).page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.includes(:followings).order(published_at: :desc).page(params[:page])
    @posts_count = @user.posts.count
  end
end
