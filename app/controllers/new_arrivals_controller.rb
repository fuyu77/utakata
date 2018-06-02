class NewArrivalsController < ApplicationController
  def index
    @posts = Post.all.order('created_at DESC').page(params[:page])
  end
end
