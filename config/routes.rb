Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :registrations => 'users/registrations'
  }
  
  get 'toppages/index'

  root to: 'toppages#index'
end
