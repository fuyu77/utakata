Rails.application.routes.draw do
  get 'kajin_search_results/index'

  get 'my_search_results/index'

  devise_for :users, :controllers => {
    :registrations => 'users/registrations'
  }
  get 'tanka/search', to: 'search_results#index' 
  get 'tanka/search/mine', to: 'my_search_results#index'
  get 'kajin/search', to: 'kajin_search_results#index'
  get 'kajin/:user_id', to: 'posts#index', as: :posts
  get 'tanka/new', to: 'posts#new', as: :new_post
  post 'tanka', to: 'posts#create'
  get 'tanka/:id', to: 'posts#show', as: :post
  delete 'tanka/:id', to: 'posts#destroy'
  root to: 'new_arrivals#index'
end
