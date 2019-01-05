# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  resources :users, path: 'kajin', only: %i[index show] do
    collection do
      get 'search'
    end
    member do
      get 'followees'
      get 'followers'
      get 'timeline'
      get 'likes'
      get 'notifications'
      get 'rensaku'
    end
  end
  resources :posts, path: 'tanka' do
    collection do
      get 'search'
      get 'my-search'
      get 'popular'
    end
    member do
      get 'followers'
    end
  end
  resources :chapters, path: 'rensaku' do
    member do
      get 'tanka'
      get 'followers'
    end
  end
  resources :relationships, only: %i[create destroy]
  resources :favorites, only: %i[create destroy]
  resources :chapter_posts, only: %i[create destroy]
  resources :infos, path: 'about', only: [:index]
  root to: 'posts#popular'
end
