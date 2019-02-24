# frozen_string_literal: true

class RelationshipsController < ApplicationController
  def create
    redirect_back(fallback_location: root_path)
    if current_user.follow(User.find(params[:follow]))
      flash[:notice] = 'フォローしました'
    else
      flash[:alert] = 'フォローできませんでした'
    end
  end

  def destroy
    redirect_back(fallback_location: root_path)
    if current_user.stop_following(User.find(params[:id]))
      flash[:notice] = 'フォローを外しました'
    else
      flash[:alert] = 'フォローを外せませんでした'
    end
  end
end
