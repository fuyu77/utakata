# frozen_string_literal: true

class RelationshipsController < ApplicationController
  def create
    followed_user = User.find(params[:follow])
    redirect_back fallback_location: root_path
    return if current_user.following?(followed_user)

    if current_user.follow(followed_user)
      flash[:notice] = 'フォローしました'
    else
      flash[:alert] = 'フォローできませんでした'
    end
  end

  def destroy
    if current_user.stop_following(User.find(params[:id]))
      flash[:notice] = 'フォローを外しました'
    else
      flash[:alert] = 'フォローを外せませんでした'
    end
    redirect_back fallback_location: root_path
  end
end
