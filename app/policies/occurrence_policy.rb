class OccurrencePolicy < ApplicationPolicy
  def update?
    user.admin? or record.habit.user_id == user.id
  end
end
