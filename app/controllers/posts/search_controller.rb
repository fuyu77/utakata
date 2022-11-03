# frozen_string_literal: true

class Posts::SearchController < ApplicationController
  def index
    redirect_to users_path if params[:search].blank?

    @search = params[:search]
    @posts = Post.includes(:user, :followings).search(@search).order('created_at DESC').page(params[:page])
  end
end
