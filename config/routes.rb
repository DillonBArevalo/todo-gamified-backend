Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resource :sessions, only: [:new, :create, :destroy]

  resources :users, only: [:create] do
      resources :tasks, only: [:index, :create]
  end

  resources :tasks, only: [:show, :edit, :destroy]
end
