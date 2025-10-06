# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = Follow.includes(:followable, :follower)
                           .where(user_id: current_user.id)
                           .order(id: :desc)
                           .page(params[:page])
    Follow.where(user_id: current_user.id, read: false).update_all(read: true)
  end
end
