class ToppagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @post = current_user.posts.build
    @posts = current_user.posts.order('created_at DESC').page(params[:page])
  end
end
