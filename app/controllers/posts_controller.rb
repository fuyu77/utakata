class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to timeline_posts_path, notice: '短歌を投稿しました'
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
      redirect_to timeline_posts_path, notice: '短歌を削除しました'
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

  def timeline
    @users = current_user.following_by_type('User').ids + [current_user.id]
    @posts = Post.where(user_id: @users).order('created_at DESC').page(params[:page])
  end

  def follower
    @post = Post.find(params[:id])
    @user = User.find(@post.user_id)
    @users = @post.followers_by_type('User').page(params[:page])
  end

  def popular
    popular_posts = Follow.where(["followable_type = :type and created_at >= :time", {type: 'Post', time: (Time.now - 1.days)}]).group('follows.followable_id').count('follows.followable_id')
    if popular_posts.present?
      popular_posts_ids = Hash[popular_posts.sort_by{ |_, v| -v }].keys
      @posts = Post.where(id: popular_posts_ids).order_by_ids(popular_posts_ids).page(params[:page])
    else
      @posts = Post.none.page(params[:page])
    end
  end

  def favorite
    @posts = current_user.following_by_type('Post').page(params[:page])
  end

  def notification
    @notifications = Follow.where(user_id: current_user.id).order('created_at DESC').page(params[:page])
    # @notifications.update_all(read: true)
  end

  private

  def post_params
    params.require(:post).permit(:tanka)
  end
end
