class RelationshipsController < ApplicationController
  def create
    if current_user.follow(User.find(params[:follow]))
      redirect_back(fallback_location: root_path)
      flash[:notice] = 'フォローしました'
    else
      redirect_back(fallback_location: root_path)
      flash[:alert] = 'フォローできませんでした'
    end
  end

  def destroy
    if current_user.stop_following(User.find(params[:id]))
      redirect_back(fallback_location: root_path)
      flash[:notice] = 'フォローを外しました'
    else
      redirect_back(fallback_location: root_path)
      flash[:alert] = 'フォローを外せませんでした'
    end
  end
end
