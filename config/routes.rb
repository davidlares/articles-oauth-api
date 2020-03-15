Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # exponse endpoints
  post 'login', to: 'access_tokens#create'
  delete 'logout', to: 'access_tokens#destroy'
  post 'sign_up', to: 'registrations#create'

  # adding a resource route (full CRUD)
  resources :articles do
    # using this block will generate the /articles/1/comments structure
    resources :comments, only: [:index, :create]
  end
end
