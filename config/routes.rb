# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :t_shirts

  # Defines the root path route ("/")
  root 't_shirts#index'
end
