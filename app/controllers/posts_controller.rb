# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[new edit]

  def index
    @posts = Post.includes(:user, :followings).order('posts.id DESC').page(params[:page])
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @tanka = @post.tanka_text
    @twitter_share_url = @post.twitter_share_url(url_for)
  end

  def new
    @post = current_user.posts.build
  end

  def edit
    @post = current_user.posts.find_by(id: params[:id])
    redirect_to root_path unless @post
  end

  def create
    if current_user.today_posts_count >= 10
      flash.now[:alert] = '1日10首まで投稿可能です'
      respond_to { |format| format.turbo_stream }
      return
    end

    post = current_user.posts.build(create_params)
    if post.save
      redirect_to posts_path, notice: '短歌を投稿しました'
    else
      flash.now[:alert] = post.errors.full_messages
      respond_to { |format| format.turbo_stream }
    end
  end

  def update
    post = current_user.posts.find(params[:id])
    if post.update(update_params)
      redirect_to post_path(id: post.id), notice: '短歌を更新しました'
    else
      flash.now[:alert] = post.errors.full_messages
      respond_to { |format| format.turbo_stream }
    end
  end

  def destroy
    post = current_user.posts.find(params[:id])
    if post.destroy
      redirect_to user_path(id: current_user.id), status: :see_other, notice: '短歌を削除しました'
    else
      redirect_back fallback_location: root_path, status: :see_other, alert: '短歌を削除できませんでした'
    end
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
    params.expect(post: %i[tanka published_at])
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
