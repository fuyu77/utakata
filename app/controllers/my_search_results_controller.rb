class MySearchResultsController < ApplicationController
  def index
    @search = params[:search]
    @posts = current_user.posts.search(params[:search]).order('created_at DESC').page(params[:page])
  end
end
