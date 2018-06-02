Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :registrations => 'users/registrations'
  }
  get 'toppages/index'
  get 'posts/user/:user_id', to: 'posts#index', as: :posts
  resources :posts, only: [:new, :create, :show, :destroy]
  root to: 'toppages#index'
end
