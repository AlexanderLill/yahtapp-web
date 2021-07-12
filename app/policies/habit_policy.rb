class HabitPolicy < GoalPolicy
  def see_all?
    user.admin?
  end

  def enable?
    user.admin? or record.user_id == user.id
  end

  def disable?
    user.admin? or record.user_id == user.id
  end
end