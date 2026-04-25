# frozen_string_literal: true

class Posts::PopularController < ApplicationController
  def index
    @posts = Post.includes(:user, :followings)
                 .joins(:popular_post)
                 .order('popular_posts.position')
                 .page(params[:page])
  end
end
