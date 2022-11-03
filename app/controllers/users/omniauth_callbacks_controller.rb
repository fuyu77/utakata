# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    @user = User.find_or_create_by_twitter_oauth(request.env['omniauth.auth'])

    if @user.persisted?
      set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
      sign_in_and_redirect @user, event: :authentication
    else
      session['devise.twitter_data'] = request.env['omniauth.auth'].except('extra')
      redirect_to new_user_registration_url
    end
  end
end
