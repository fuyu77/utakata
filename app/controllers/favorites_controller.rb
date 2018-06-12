class FavoritesController < ApplicationController
  def create
    current_user.follow(Post.find(params[:follow]))
    redirect_back(fallback_location: root_path)
  end

  def destroy
    current_user.stop_following(Post.find(params[:id]))
    redirect_back(fallback_location: root_path)
  end
end
