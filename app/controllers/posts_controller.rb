# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy my_search]

  def new
    @post = current_user.posts.build
  end

  def create
    if current_user.today_posts_count >= 10
      flash[:alert] = '1日10首まで投稿可能です'
      redirect_back fallback_location: root_path and return
    end

    post = current_user.posts.build(create_params)
    if post.save
      redirect_to posts_path, notice: '短歌を投稿しました'
    else
      flash[:alert] = post.errors.full_messages
      redirect_back fallback_location: root_path
    end
  end

  def index
    @posts = Post.includes(:user, :followings).order('posts.created_at DESC').page(params[:page])
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @tanka = @post.tanka_text
    @twitter_url = @post.twitter_url(url_for(only_path: false))
  end

  def edit
    @post = current_user.posts.find_by(id: params[:id])
    redirect_to root_path and return unless @post

    @post.tanka = @post.input_tanka
  end

  def update
    post = current_user.posts.find(params[:id])
    if post.update(update_params)
      redirect_to post_path(id: post.id), notice: '短歌を更新しました'
    else
      flash[:alert] = post.errors.full_messages
      redirect_back fallback_location: root_path
    end
  end

  def destroy
    post = current_user.posts.find(params[:id])
    if post.destroy
      redirect_to user_path(id: current_user.id), status: :see_other, notice: '短歌を削除しました'
    else
      flash[:alert] = '削除できませんでした'
      redirect_back fallback_location: root_path, status: :see_other
    end
  end

  def search
    redirect_to users_path and return if params[:search].blank?

    @search = params[:search]
    @posts = Post.includes(:user, :followings).search(@search).order('created_at DESC').page(params[:page])
  end

  def my_search
    @search = params[:search]
    @posts = current_user.posts
                         .includes(:followings)
                         .search(params[:search])
                         .order('created_at DESC')
                         .page(params[:page])
  end

  def followers
    @post = Post.find(params[:id])
    @user = @post.user
    follower_ids = Follow.where(followable_type: 'Post', followable_id: @post.id)
                         .order('created_at DESC')
                         .pluck(:follower_id)
    @users = User.where(id: follower_ids).order_by_ids(follower_ids).page(params[:page])
  end

  def popular
    @posts = Post.includes(:user, :followings)
                 .joins('INNER JOIN follows ON posts.id = follows.followable_id')
                 .where(
                   'follows.followable_type = :type and follows.created_at >= :time',
                   { type: 'Post', time: 1.week.ago }
                 )
                 .group('posts.id')
                 .order('count(follows.followable_id) desc')
                 .order('posts.created_at')
                 .page(params[:page])
  end

  private

  def sanitize(tanka)
    sanitized_tanka = helpers.sanitize(tanka, tags: %w[ruby rt tate], attributes: %w[])
    sanitized_tanka.gsub('<rt>', '<rp>（</rp><rt>')
                   .gsub('</rt>', '</rt><rp>）</rp>')
                   .gsub('<tate>', '<span class="tate">')
                   .gsub('</tate>', '</span>')
  end

  def post_params
    params.require(:post).permit(:tanka, :published_at)
  end

  def create_params
    params = post_params
    params[:tanka] = sanitize(post_params[:tanka])
    params[:published_at] = Time.zone.now
    params
  end

  def update_params
    params = post_params
    params[:tanka] = sanitize(post_params[:tanka])
    params
  end
end
