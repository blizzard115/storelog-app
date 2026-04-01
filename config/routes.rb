Rails.application.routes.draw do
  devise_for :users
  root "home#top"

  resources :stores, only: [:new, :create]
  get "store_join", to: "stores#join"
  post "store_join", to: "stores#join_create"

  resources :posts, only: [:index, :new, :create, :show, :destroy] do
    resource :read, only: [:create]
  end

  resources :users, only: [:show]
end
