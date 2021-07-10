class GoalPolicy < ApplicationPolicy
  def set_user?
    user.admin?
  end
  def set_template?
    user.admin?
  end
  def see_all?
    user.admin?
  end
end