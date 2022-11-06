# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    user = User.find_or_create_by_twitter_oauth(request.env['omniauth.auth'])
    set_flash_message(:notice, :success, kind: 'Twitter')
    sign_in_and_redirect user, event: :authentication
  end
end
