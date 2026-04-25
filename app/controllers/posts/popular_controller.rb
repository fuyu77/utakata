# frozen_string_literal: true

class Posts::PopularController < ApplicationController
  def index
    @posts = Post.includes(:user, :followings)
                 .joins('INNER JOIN popular_posts ON popular_posts.post_id = posts.id')
                 .order('popular_posts.position')
                 .page(params[:page])
  end
end
