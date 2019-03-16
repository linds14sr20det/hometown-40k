Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  root 'application#home'

  resources :users #TODO: This needs to become protected unless editing self

  resources :cohorts do
    get :find, on: :collection
    get :my_events, on: :collection
  end
  resources :tickets, only: [:index, :show] do
    post :add_to_cart, on: :member
    get :remove_from_cart, on: :collection
    get :cart, on: :collection
    get :success, on: :collection
  end
  post '/checkout' => 'paypal#checkout'
  post '/execute' =>  'paypal#execute'
  resources :password_resets, only: [:new, :create, :edit, :update]

  resources :registrants
end
