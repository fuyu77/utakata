# frozen_string_literal: true

class Posts::SearchController < ApplicationController
  before_action :authenticate_user!

  def index
    redirect_to users_path if params[:keyword].blank?

    @keyword = params[:keyword]
    @posts = Post.includes(:user, :followings).like('tanka', @keyword).order('id DESC').page(params[:page])
  end
end
