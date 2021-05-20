class DashboardController < ApplicationController
  before_action :authenticate_user!
  layout 'boxed' # sets the layout for all views with this controller

  def index
    @goals = current_user.goals
    occs = current_user.occurrences.includes(habit: :goal)
                       .where('scheduled_at >= ?', DateTime.now.beginning_of_week(start_day=:monday))
                       .where('scheduled_at <= ?', DateTime.now.end_of_week).order(:scheduled_at)

    # group by weekday
    @schedule = occs.group_by { |occ| occ.scheduled_at.strftime('%A').downcase.to_sym }

    # calculate streaks
    occs = current_user.occurrences.includes(:habit).where('scheduled_at <= ?', DateTime.now).order(:scheduled_at).limit(100)
    @streaks = occs.group_by{ |occ| occ.habit.goal_id }

    # get all metrics
    configs = current_user.experience_sample_configs

    # get this weeks metrics
    current_week_metrics = current_user.samplings.includes(:experience_sample_config)
                           .where('scheduled_at >= ?', DateTime.now.beginning_of_week(start_day=:monday))
                           .where('scheduled_at <= ?', DateTime.now.end_of_week)
                           .group(:experience_sample_config_id).average(:value)

    # get last weeks metrics
    last_week_metrics = current_user.samplings.includes(:experience_sample_config)
                           .where('scheduled_at >= ?', DateTime.now.beginning_of_week(start_day=:monday) - 7.days)
                           .where('scheduled_at <= ?', DateTime.now.end_of_week - 7.days)
                           .group(:experience_sample_config_id).average(:value)

    @metrics = configs.map { |config| {
      config: config,
      current_week: current_week_metrics[config.id]&.round(2),
      last_week: last_week_metrics[config.id]&.round(2),
      difference: percentage_difference(current_week_metrics[config.id], last_week_metrics[config.id])
    }}
  end

  def percentage_difference(this_week, last_week)
    unless this_week
      return 0
    end
    unless this_week
      return 0
    end
    (((this_week - last_week) / last_week) * 100).round(2)
  end

end
