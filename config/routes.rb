# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  resources :users, path: 'kajin', only: %i[index show] do
    scope module: :users, as: :users do
      resources :followees, only: %i[index]
      resources :followers, only: %i[index]
      collection do
        resources :search, only: %i[index]
      end
    end
  end
  resources :posts, path: 'tanka' do
    scope module: :posts, as: :posts do
      resources :followers, only: %i[index]
      collection do
        resources :popular, only: %i[index]
        resources :search, only: %i[index]
        resources :my_search, only: %i[index], path: 'my-search'
      end
    end
  end
  resources :relationships, param: :user_id, only: %i[create destroy]
  resources :favorites, param: :post_id, only: %i[index create destroy]
  resources :timeline, only: %i[index]
  resources :notifications, only: %i[index]
  resources :about, only: %i[index]
  resources :terms, only: %i[index]
  resources :privacy, only: %i[index]
  resources :donations, only: %i[index]
  get '/users', to: redirect('/users/edit')
  root to: 'posts/popular#index'
end
