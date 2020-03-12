Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # exponse endpoints
  post 'login', to: 'access_tokens#create'
  delete 'logout', to: 'access_tokens#destroy'
  # adding a resource route (full CRUD)
  resources :articles, only: [:index, :show]
end
