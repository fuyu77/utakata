# frozen_string_literal: true

class RelationshipsController < ApplicationController
  def create
    user = User.find(params[:user_id])
    redirect_back fallback_location: root_path and return if current_user.following?(user)

    current_user.follow(user)
    redirect_back fallback_location: root_path, notice: 'フォローしました'
  end

  def destroy
    current_user.stop_following(User.find(params[:user_id]))
    redirect_back fallback_location: root_path, notice: 'フォローを外しました'
  end
end
