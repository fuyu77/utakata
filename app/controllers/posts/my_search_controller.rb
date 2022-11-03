# frozen_string_literal: true

class Posts::MySearchController < ApplicationController
  before_action :authenticate_user!

  def index
    @search = params[:search]
    @posts = current_user.posts
                         .includes(:followings)
                         .search(params[:search])
                         .order('created_at DESC')
                         .page(params[:page])
  end
end
