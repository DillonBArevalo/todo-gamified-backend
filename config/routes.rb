Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resource :sessions, only: [:new, :create]

  resources :users, only: [:create]

  resources :tasks, except: [:new, :edit]
end
