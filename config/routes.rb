Rails.application.routes.draw do


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'welcome#index'
  get 'dashboard' => "dashboard#index"

  get 'experimentation' => "experimentation#index"

  # Devise (login/logout) for HTML requests
  devise_for :users, controllers: { registrations: 'registrations' }, defaults: { format: :html }, path: '', sign_out_via: %i[get post delete], path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'register'
  }

  devise_scope :user do
    get :settings, to: 'registrations#settings'
    put :settings, to: 'registrations#update_settings'
  end

  # resources will automatically create all CRUD paths
  # the only attribute can be used to limit it to certain actions
  resources :goals do
    collection do
      get 'select'
    end
  end

  resources :habits
  resources :reflections
  resources :experience_sample_configs

  # API part
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get 'post/index'
      devise_scope :user do
        post :auth, to: 'sessions#create'
        delete :auth, to: 'sessions#destroy'
      end
      resources :users, only: %w[show] do
        resources :occurrences, only: [:index, :update]
        resources :samplings, only: [:index, :update]
      end
    end
    namespace :v2 do
      # Things yet to come
    end
  end
end
