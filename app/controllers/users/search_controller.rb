# frozen_string_literal: true

class Users::SearchController < ApplicationController
  def index
    @search = params[:search]
    @users = User.search(params[:search]).order('created_at DESC').page(params[:page])
  end
end
