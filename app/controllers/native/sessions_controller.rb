# frozen_string_literal: true

class Native::SessionsController < ApplicationController
  before_action :authenticate_user!

  def show; end
end
