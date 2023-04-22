# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :t_shirts
  resources :orders, only: %i[index show create]

  get '/cart', to: 'carts#show', as: 'cart_show'

  resources :user_cart_t_shirts, only: [] do
    post 'update_cart_quantity', on: :collection
  end

  # Defines the root path route ("/")
  root 't_shirts#index'
end
