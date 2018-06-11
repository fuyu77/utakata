Rails.application.routes.draw do
  get 'posts/search'

  get 'posts/search_mine'

  get 'users/search'

  devise_for :users, :controllers => {
    :registrations => 'users/registrations'
  }
  
  resources :users, path: 'kajin', only: [:show] do
    collection do
      get 'search'
    end
  end
  
  resources :posts, path: 'tanka', only: [:index, :show, :new, :create, :destroy] do
    collection do
      get 'search'
    end
  end
  get 'tanka/search/mine', to: 'posts#search_mine'
  
  root to: 'posts#index'
end
