class KajinSearchResultsController < ApplicationController
  def index
    @search = params[:search]
    @users = User.search(params[:search]).order('created_at DESC').page(params[:page])
  end
end
