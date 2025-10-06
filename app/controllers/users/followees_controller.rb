# frozen_string_literal: true

class Users::FolloweesController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    user_ids = Follow.where(followable_type: 'User', follower_id: @user.id)
                     .order(id: :desc)
                     .pluck(:followable_id)
    @users = User.where(id: user_ids).order_by_ids(user_ids).page(params[:page])
  end
end
