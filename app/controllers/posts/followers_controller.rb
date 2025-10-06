# frozen_string_literal: true

class Posts::FollowersController < ApplicationController
  def index
    @post = Post.find(params[:post_id])
    user_ids = Follow.where(followable_type: 'Post', followable_id: @post.id)
                     .order(id: :desc)
                     .pluck(:follower_id)
    @users = User.where(id: user_ids).order_by_ids(user_ids).page(params[:page])
  end
end
