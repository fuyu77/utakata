class RelationshipsController < ApplicationController
  def create
    @follower = User.find(params[:follower])
    @followee = User.find(params[:followee])
    @follower.follow(@followee)
    redirect_back(fallback_location: root_path)
  end

  def destroy
  end
end
