class ExperimentationController < ApplicationController
  before_action :authenticate_user!
  layout 'boxed' # sets the layout for all views with this controller
  def index
    reflections = current_user.habit_reflections.includes(habit: :goal)
                               .where('habit_reflections.created_at <= ?', DateTime.now).order('habit_reflections.created_at')

    @goals = reflections.map(&:habit).uniq.group_by(&:goal_id)
    habit_reflections = reflections.group_by { |habit_ref| habit_ref.habit.id }
    @habit_avg_ratings = {}
    habit_reflections.each do |key, habit_refs|
      sum = 0.0
      habit_refs.each do |habit_ref|
        sum += habit_ref.rating
      end
      @habit_avg_ratings[key] = sum / habit_refs.size
    end

  end
end
