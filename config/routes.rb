Rails.application.routes.draw do
  resources :rooms do
    member do
      post :apply
      post :cancel
      post :next
    end
  end
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
