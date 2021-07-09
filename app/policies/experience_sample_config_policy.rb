class ExperienceSampleConfigPolicy < GoalPolicy
  def set_goal?
    user.admin?
  end

  def show?
    user.admin? or record.user_id == user.id
  end

end
