Rails.application.routes.draw do
  # Profile management
  get "/profile", to: "profile#show", as: :profile
  get "/profile/edit", to: "profile#edit", as: :edit_profile
  patch "/profile", to: "profile#update"
  get "/profile/password", to: "profile#password", as: :change_password
  patch "/profile/password", to: "profile#update_password"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Authentication routes
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  # User registration
  get "/register/:token", to: "registrations#new", as: :register
  post "/register/:token", to: "registrations#create"

  # Secret registration page
  get "/letsgo", to: "registrations#new", as: :letsgo
  post "/letsgo", to: "registrations#create"

  # Admin namespace
  namespace :admin do
    root "dashboard#index"
    resources :trips do
      resources :accommodations do
        resources :rooms
      end
      resources :golf_rounds
      resources :itinerary_items
      resources :betting_pools
      member do
        get :participants
        patch :confirm_deposit
        patch :unconfirm_deposit
        delete :unregister_user
      end
    end
    resources :users do
      member do
        post :assign_trip
        delete :remove_from_trip
        post :update_room
      end
    end
    resources :invitation_links, only: [:index, :create, :destroy]
  end

  # User dashboard and room selection
  root "dashboard#index"
  resources :trips, only: [:show] do
    member do
      post :register
      get :room_selection
      post :select_room
      get :registered_users
    end
    resources :rooms, only: [:show]
  end

  resources :room_reservations, only: [:create, :destroy]
  resources :betting_participations, only: [:create, :destroy]

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
