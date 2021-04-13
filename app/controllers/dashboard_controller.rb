class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @goals = current_user.goals
    occs = current_user.occurrences.includes(:habit)
                       .where('scheduled_at >= ?', DateTime.now.beginning_of_week(start_day=:monday))
                       .where('scheduled_at <= ?', DateTime.now.end_of_week).order(:scheduled_at)

    # group by weekday
    @schedule = occs.group_by{ |occ| occ.scheduled_at.strftime('%A').downcase.to_sym }
  end
end
