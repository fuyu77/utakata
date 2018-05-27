class PostsController < ApplicationController
  before_action :authenticate_user!

  def new
    @user = current_user
    @post = current_user.posts.build
    @posts = current_user.posts.order('created_at DESC')
  end

  def create
    @post = current_user.posts.build(post_params)
    @post.save
  end

  private

  def post_params
    params.require(:post).permit(:tanka)
  end
end
