Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :registrations => 'users/registrations'
  }
  get 'new_arrivals/index'
  get 'posts/user/:user_id', to: 'posts#index', as: :posts
  resources :posts, only: [:new, :create, :show, :destroy]
  root to: 'new_arrivals#index'
end
