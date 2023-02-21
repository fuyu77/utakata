# frozen_string_literal: true

class Users::DeviseController < ApplicationController
  after_action :set_flash

  respond_to :html, :turbo_stream

  private

  def set_flash
    flash[:alert] = resource.errors.full_messages if resource&.errors.present?
  end
end
