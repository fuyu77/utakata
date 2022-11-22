# frozen_string_literal: true

class Users::DeviseController < ApplicationController
  after_action :set_flash

  class Responder < ActionController::Responder
    def to_turbo_stream
      controller.render(options.merge(formats: :html))
    rescue ActionView::MissingTemplate => e
      raise e if get?

      if has_errors? && default_action
        redirect_to request.referer
      else
        redirect_to navigation_location
      end
    end
  end

  self.responder = Responder
  respond_to :html, :turbo_stream

  private

  def set_flash
    flash[:alert] = resource.errors.full_messages if resource&.errors.present?
  end
end
