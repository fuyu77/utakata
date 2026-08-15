# frozen_string_literal: true

class Native::MypagesController < ApplicationController
  before_action :authenticate_user!

  def show
    redirect_to user_path(current_user), status: :see_other
  end
end
