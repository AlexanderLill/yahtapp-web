class RegistrationsController < Devise::RegistrationsController
  def after_sign_in_path_for(resource)
    dashboard_path
  end
  def after_sign_up_path_for(resource)
    dashboard_path
  end
  def after_inactive_sign_up_path_for(resource)
    dashboard_path
  end
end