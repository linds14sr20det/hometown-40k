Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :rounds
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  root 'application#home'

  resources :users #TODO: This needs to become protected unless editing self

  resources :cohorts do
    get :find, on: :collection
    get :my_events, on: :collection
    post :search, on: :collection
    post :my_search, on: :collection
  end

  resources :tickets, only: [:index, :show] do
    post :add_to_cart, on: :member
    get :remove_from_cart, on: :collection
    get :cart, on: :collection
    get :cohorts_cart, on: :collection
    get :success, on: :collection
  end

  resources :rounds, only: [:index, :new, :show] do
    post :complete_round, on: :collection
  end

  resources :round_individuals, only: [:edit, :update]

  post '/checkout' => 'paypal#checkout'
  post '/execute' =>  'paypal#execute'
  resources :password_resets, only: [:new, :create, :edit, :update]

  resources :registrants do
    post :check_in_player, on: :member
    get :toggle_start_event, on: :collection
  end
end
