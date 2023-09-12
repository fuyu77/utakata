# frozen_string_literal: true

class Users::FollowersController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    user_ids = Follow.where(followable_type: 'User', followable_id: @user.id)
                     .order('id DESC')
                     .pluck(:follower_id)
    @users = User.where(id: user_ids).order_by_ids(user_ids).page(params[:page])
  end
end
