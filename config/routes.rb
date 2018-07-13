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
      get 'timeline'
      get 'favorite'
      get 'notifications'
    end
  end
  
  resources :posts, path: 'tanka', only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    collection do
      get 'search'
      get 'popular'
    end
    member do
      get 'follower'
    end
  end
  get 'tanka/search/mine', to: 'posts#search_mine'

  resources :relationships, only: [:create, :destroy]
  resources :favorites, only: [:create, :destroy]
  
  resources :infos, path: 'info', only: [:index]
  
  root to: 'posts#popular'
end
