Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :app do
    root 'application#show'
    get '*path', to: 'application#show'
  end
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'
    end
  end
end
