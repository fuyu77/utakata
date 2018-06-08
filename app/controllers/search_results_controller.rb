class SearchResultsController < ApplicationController
  def index
    @search = params[:search]
    @posts = Post.search(@search).order('created_at DESC').page(params[:page])
  end
end
