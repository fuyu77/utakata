# frozen_string_literal: true

class Users::SearchController < ApplicationController
  def index
    @keyword = params[:keyword]
    @users = User.like('name', params[:keyword]).order('id DESC').page(params[:page])
  end
end
