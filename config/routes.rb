Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :registrations => 'users/registrations'
  }
  
  resources :users, path: 'kajin', only: [:show] do
    collection do
      get 'search'
    end
    member do
      get 'follow'
      get 'follower'
    end
  end
  
  resources :posts, path: 'tanka', only: [:index, :show, :new, :create, :destroy] do
    collection do
      get 'search'
      get 'timeline'
    end
  end
  get 'tanka/search/mine', to: 'posts#search_mine'

  resources :relationships, only: [:create, :destroy]
  
  root to: 'posts#index'
end
