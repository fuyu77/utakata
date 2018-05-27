Rails.application.routes.draw do
  get 'posts/new'

  get 'posts/create'

  get 'posts/destroy'

  devise_for :users, :controllers => {
    :registrations => 'users/registrations'
  }
  
  get 'toppages/index'

  root to: 'toppages#index'

  resources :posts, only: [:new, :create, :destroy]

  get 'users/:id'
end
