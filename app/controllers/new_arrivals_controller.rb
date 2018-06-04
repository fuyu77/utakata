class NewArrivalsController < ApplicationController
  def index
    @posts = Post.limit(310).order('created_at DESC').page(params[:page])
  end
end
