# frozen_string_literal: true

class Posts::PopularController < ApplicationController
  def index
    @posts = Post.includes(:user, :followings)
                 .joins('INNER JOIN follows ON posts.id = follows.followable_id')
                 .where(
                   'follows.followable_type = :type and follows.created_at >= :time',
                   { type: 'Post', time: 1.week.ago }
                 )
                 .group('posts.id')
                 .order('count(follows.followable_id) desc')
                 .order('posts.created_at')
                 .page(params[:page])
  end
end
