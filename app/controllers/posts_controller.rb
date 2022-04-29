# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy my_search]

  def new
    @post = current_user.posts.build
  end

  def create
    today_posts = current_user.posts.where('created_at >= ?', Time.zone.now.midnight)
    if today_posts.count >= 10
      flash[:alert] = '1日10首まで投稿可能です'
      redirect_back fallback_location: root_path
      return
    end
    @post = current_user.posts.build(post_params)
    @post.tanka = Post.add_html_tag(@post.tanka)
    @post.published_at = Time.zone.now
    if @post.save
      redirect_to posts_path, notice: '短歌を投稿しました'
    else
      flash[:alert] = @post.errors.full_messages
      redirect_back fallback_location: root_path
    end
  end

  def index
    @posts = Post.includes(:user, :followings).order('posts.created_at DESC').page(params[:page])
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    tanka = helpers.strip_tags(@post.tanka)
    twitter_user = URI.encode_www_form_component(@user.name)
    twitter_tanka = URI.encode_www_form_component(tanka)
    url = url_for(only_path: false)
    @twitter_path = "https://twitter.com/share?url=#{url}&text=#{twitter_tanka}%0a／#{twitter_user}%0a"

    @title = "#{tanka}／#{@user.name}"
    @description = "#{@user.name}の短歌：#{tanka}"
  end

  def edit
    begin
      @post = current_user.posts.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path
      return
    end
    @post.tanka = Post.remove_html_tag(@post.tanka)
  end

  def update
    @post = current_user.posts.find(params[:id])
    # 変数に代入しないと中身を変更できない
    update_params = post_params
    update_params[:tanka] = Post.add_html_tag(update_params[:tanka])
    if @post.update(update_params)
      redirect_to post_path(id: @post.id), notice: '短歌を更新しました'
    else
      flash[:alert] = @post.errors.full_messages
      redirect_back fallback_location: root_path
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    if @post.destroy
      redirect_to user_path(id: current_user.id), status: :see_other, notice: '短歌を削除しました'
    else
      flash[:alert] = '削除できませんでした'
      redirect_back fallback_location: root_path, status: :see_other
    end
  end

  def search
    redirect_to users_path if params[:search].blank?
    @search = params[:search]
    @posts = Post.includes(:user, :followings).search(@search).order('created_at DESC').page(params[:page])
  end

  def my_search
    @search = params[:search]
    @posts = current_user.posts.includes(:followings)
                         .search(params[:search])
                         .order('created_at DESC')
                         .page(params[:page])
  end

  def followers
    @post = Post.find(params[:id])
    @user = @post.user
    followers = Follow.where(followable_type: 'Post', followable_id: @post.id)
                      .order('created_at DESC')
                      .pluck(:follower_id)
    @users = if followers.present?
               User.where(id: followers).order_by_ids(followers).page(params[:page])
             else
               User.none.page(params[:page])
             end
  end

  def popular
    @posts = Post.includes(:user, :followings)
                 .joins('INNER JOIN follows ON posts.id = follows.followable_id')
                 .where('follows.followable_type = :type and follows.created_at >= :time',
                        { type: 'Post', time: 1.week.ago })
                 .group('posts.id')
                 .order('count(follows.followable_id) desc')
                 .order('posts.created_at')
                 .page(params[:page])
  end

  private

  def post_params
    params.require(:post).permit(:tanka, :published_at)
  end
end
