class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :configure_permitted_parameters, if: :devise_controller?

  # configures the permitted parameters for devise (i.e. used on registration / sign up)
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username,:firstname,:lastname, :email])
    devise_parameter_sanitizer.permit(:account_update, keys: [:firstname,:lastname, :email, :password, :password_confirmation])
  end
end
