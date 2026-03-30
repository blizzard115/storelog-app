Rails.application.routes.draw do
  devise_for :users
  root "home#top"

  resources :posts, only: [:index, :new, :create, :show, :destroy] do
    resource :read, only: [:create]
  end

  resources :users, only: [:show]
end
