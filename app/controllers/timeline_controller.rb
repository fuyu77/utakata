# frozen_string_literal: true

class TimelineController < ApplicationController
  before_action :authenticate_user!

  def index
    user_ids = current_user.following_by_type('User').pluck(:followable_id) + [current_user.id]
    @posts = Post.includes(:user, :followings).where(user_id: user_ids).order('id DESC').page(params[:page])
  end
end
