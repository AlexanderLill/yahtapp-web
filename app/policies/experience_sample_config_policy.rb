class ExperienceSampleConfigPolicy < GoalPolicy
  def set_goal?
    user.admin?
  end
end
