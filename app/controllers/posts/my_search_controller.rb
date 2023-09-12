# frozen_string_literal: true

class Posts::MySearchController < ApplicationController
  before_action :authenticate_user!

  def index
    @keyword = params[:keyword]
    @posts = current_user.posts
                         .includes(:followings)
                         .like('tanka', params[:keyword])
                         .order('id DESC')
                         .page(params[:page])
  end
end
