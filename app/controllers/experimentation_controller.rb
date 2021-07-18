class ExperimentationController < ApplicationController
  before_action :authenticate_user!
  layout 'boxed' # sets the layout for all views with this controller

  def index
    param_start = params[:start].to_s
    @start_datetime = param_start.present? ? DateTime.parse(param_start) : DateTime.now.beginning_of_week
    @first_reflection_at = current_user.occurrences.order('scheduled_at').first.scheduled_at

    @goals = current_user.goals

    @current_period_start = @start_datetime.beginning_of_day
    @current_period_end = @current_period_start.end_of_day + 6.days

    @last_period_start = @start_datetime.beginning_of_day - 7.days
    @last_period_end = @current_period_start.end_of_day - 1.days

    @has_data_before_start_date = current_user.created_at < @last_period_end


  end




end
