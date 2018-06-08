class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :ensure_domain
  
  FQDN = 'utakatanka.jp'
 
  def ensure_domain
   return unless /\.herokuapp.com/ =~ request.host
   port = ":#{request.port}" unless [80, 443].include?(request.port)
   redirect_to "#{request.protocol}#{FQDN}#{port}#{request.path}", status: :moved_permanently
  end

  protected
 
  def configure_permitted_parameters
    added_attrs = [:name, :profile, :twitter_id, :avatar]
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end
end
