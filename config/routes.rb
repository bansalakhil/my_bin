Rails.application.routes.draw do

  get "/auth/google_oauth2/callback", to: "sessions#create"
  get '/login', to: 'sessions#login', as: :login


  root to: "home#index"

  resources :js_bins do
    member do
      get :qunit
    end
    resources :versions
  end


  resources :ruby_bins do
    resources :versions
  end
  
  resource :sessions

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
