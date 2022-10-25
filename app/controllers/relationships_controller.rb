# frozen_string_literal: true

class RelationshipsController < ApplicationController
  def create
    @user = User.find(params[:user_id])
    return if current_user.following?(@user)

    current_user.follow(@user)
    flash.now[:notice] = 'フォローしました'
    respond_to { |format| format.turbo_stream }
  end

  def destroy
    @user = User.find(params[:id])
    current_user.stop_following(@user)
    flash.now[:notice] = 'フォローを外しました'
    respond_to { |format| format.turbo_stream }
  end
end
