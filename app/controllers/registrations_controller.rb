class RegistrationsController < Devise::RegistrationsController

  layout 'boxed', only: [:edit]

  def after_sign_in_path_for(resource)
    dashboard_path
  end
  def after_sign_up_path_for(resource)
    dashboard_path
  end
  def after_inactive_sign_up_path_for(resource)
    dashboard_path
  end
  # also used when redirecting after successful password reset
  def after_update_path_for(resource)
    dashboard_path
  end
end