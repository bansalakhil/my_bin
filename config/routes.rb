Rails.application.routes.draw do
  root to: "js_bins#index"
  resources :js_bins do
    resources :versions
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
