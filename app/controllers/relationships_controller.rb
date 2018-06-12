class RelationshipsController < ApplicationController
  def create
    @follower = User.find(params[:follower])
    @follow = User.find(params[:follow])
    if @follower.follow(@follow)
      redirect_back(fallback_location: root_path)
      flash[:notice] = 'フォローしました'
    else
      redirect_back(fallback_location: root_path)
      flash[:alert] = 'フォローできませんでした'
    end
  end

  def destroy
    @follower = User.find(params[:follower])
    @follow = User.find(params[:follow])
    if @follower.stop_following(@follow)
      redirect_back(fallback_location: root_path)
      flash[:notice] = 'フォローを外しました'
    else
      redirect_back(fallback_location: root_path)
      flash[:alert] = 'フォローを外せませんでした'
    end
  end
end
