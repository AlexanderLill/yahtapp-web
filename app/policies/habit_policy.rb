class HabitPolicy < GoalPolicy
  def see_all?
    user.admin?
  end
end