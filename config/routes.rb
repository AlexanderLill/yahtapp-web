Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'welcome#index'
  get 'dashboard' => "dashboard#index"

  # Devise (login/logout) for HTML requests
  devise_for :users, controllers: { registrations: 'registrations' }, defaults: { format: :html }, path: '', sign_out_via: %i[get post delete], path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'register'
  }

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get 'post/index'
      devise_scope :user do
        post :auth, to: 'sessions#create'
        delete :auth, to: 'sessions#destroy'
      end
      resources :users, only: %w[show]
    end
    namespace :v2 do
      # Things yet to come
    end
  end
end
