class ReflectionPolicy < ApplicationPolicy
  def set_user?
    user.admin?
  end
end