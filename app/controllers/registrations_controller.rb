class RegistrationsController < Devise::RegistrationsController

  layout 'boxed', only: [:settings, :update_settings]

  def settings
    @user = current_user
    render :settings
  end

  def update_settings
    @user = current_user
    if @user.update(settings_update_params)
      render :settings
    else
      render :settings
    end
  end

  def settings_update_params
    devise_parameter_sanitizer.sanitize(:settings)
  end


  def after_sign_in_path_for(resource)
    dashboard_path
  end
  def after_sign_up_path_for(resource)
    onboarding_url
  end
  def after_inactive_sign_up_path_for(resource)
    dashboard_path
  end
  # also used when redirecting after successful password reset
  def after_update_path_for(resource)
    dashboard_path
  end
end