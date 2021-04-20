class DashboardController < ApplicationController
  before_action :authenticate_user!
  layout 'boxed' # sets the layout for all views with this controller
  def index
    @goals = current_user.goals
    occs = current_user.occurrences.includes(habit: :goal)
                       .where('scheduled_at >= ?', DateTime.now.beginning_of_week(start_day=:monday))
                       .where('scheduled_at <= ?', DateTime.now.end_of_week).order(:scheduled_at)

    # group by weekday
    @schedule = occs.group_by{ |occ| occ.scheduled_at.strftime('%A').downcase.to_sym }

    # calculate streaks
    occs = current_user.occurrences.includes(:habit).where('scheduled_at <= ?', DateTime.now).order(:scheduled_at).limit(100)
    @streaks = occs.group_by{ |occ| occ.habit.goal_id }
  end
end
