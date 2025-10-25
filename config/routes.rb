Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
  namespace :file do
    resources :entries, only: :create
    resources :results, only: :create
  end
  resources :results, only: :create
  resources :shows, only: [] do
    resources :entries, only: :index, controller: "shows/entries"
    resources :results, only: :index, controller: "shows/results"
  end
end
