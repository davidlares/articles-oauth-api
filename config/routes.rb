Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # adding a resource route (full CRUD)
  resources :articles, only: [:index]
end
