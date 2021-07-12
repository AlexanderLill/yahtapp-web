class ExperienceSampleConfigPolicy < GoalPolicy
  def set_goal?
    user.admin?
  end
  def see_all?
    user.admin?
  end
end
