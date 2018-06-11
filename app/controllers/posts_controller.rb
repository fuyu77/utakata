class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to user_path(id: current_user), notice: '短歌を投稿しました'
    else
      redirect_back(fallback_location: root_path)
      flash[:alert] = @post.errors.full_messages
    end
  end

  def index
    @posts = Post.all.order('created_at DESC').page(params[:page])
  end

  def show
    @post = Post.find(params[:id])
    @user = User.find(@post.user_id)
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      redirect_to user_path(id: current_user), notice: '短歌を削除しました'
    else
      redirect_back(fallback_location: root_path)
      flash[:alert] = '削除できませんでした'
    end
  end

  def search
    @search = params[:search]
    @posts = Post.search(@search).order('created_at DESC').page(params[:page])
  end

  def search_mine
    @search = params[:search]
    @posts = current_user.posts.search(params[:search]).order('created_at DESC').page(params[:page])
  end

  private

  def post_params
    params.require(:post).permit(:tanka)
  end
end
