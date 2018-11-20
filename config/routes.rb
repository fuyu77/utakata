# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
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

  resources :posts, path: 'tanka', only: %i[index show new create edit update destroy] do
    collection do
      get 'search'
      get 'popular'
    end
    member do
      get 'follower'
    end
  end
  get 'tanka/search/mine', to: 'posts#search_mine'

  resources :relationships, only: %i[create destroy]
  resources :favorites, only: %i[create destroy]

  resources :infos, path: 'info', only: [:index]

  root to: 'posts#popular'
end
