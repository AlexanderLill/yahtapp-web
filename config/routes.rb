Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  #resources :users
  devise_scope :user do
    get "/login" => "devise/sessions#new" # custom path to login/sign_in
    get "/register" => "devise/registrations#new", as: "new_user_registration" # custom path to sign_up/registration
  end

  devise_for :users, controllers: { registrations: 'registrations' }

  scope :api, defaults: { format: :json } do
    namespace :v1 do
      get 'post/index'
      post :auth, to: 'authentication#create'
      get  '/auth' => 'authentication#fetch'
    end
    namespace :v2 do
      # Things yet to come
    end
  end
end
