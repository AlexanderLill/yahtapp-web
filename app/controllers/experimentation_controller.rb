class ExperimentationController < ApplicationController
  before_action :authenticate_user!
  layout 'boxed' # sets the layout for all views with this controller

  def index
    param_start = params[:start].to_s
    @start_datetime = DateTime.parse(param_start)

    pre_reflections = current_user.habit_reflections.includes(habit: :goal)
                                  .where('habit_reflections.created_at < ?', @start_datetime).order('habit_reflections.created_at')

    post_reflections = current_user.habit_reflections.includes(habit: :goal)
                                  .where('habit_reflections.created_at >= ?', @start_datetime).order('habit_reflections.created_at')

    @goals = post_reflections.map(&:habit).uniq.group_by(&:goal_id)

    pre_habit_reflections = pre_reflections.group_by { |habit_ref| habit_ref.habit.id }
    post_habit_reflections = post_reflections.group_by { |habit_ref| habit_ref.habit.id }


    @pre_habit_avg_ratings = {}
    pre_habit_reflections.each do |key, habit_refs|
      sum = 0.0
      habit_refs.each do |habit_ref|
        sum += habit_ref.rating
      end
      @pre_habit_avg_ratings[key] = sum / habit_refs.size
    end

    @post_habit_avg_ratings = {}
    post_habit_reflections.each do |key, habit_refs|
      sum = 0.0
      habit_refs.each do |habit_ref|
        sum += habit_ref.rating
      end
      @post_habit_avg_ratings[key] = sum / habit_refs.size
    end

    @pre_habit_reflections_count = {}
    pre_habit_reflections.each do |key, habit_refs|
      sum = 0
      habit_refs.each do |habit_ref|
        sum = sum + 1
      end
      @pre_habit_reflections_count[key] = sum
    end

    @post_habit_reflections_count = {}
    post_habit_reflections.each do |key, habit_refs|
      sum = 0
      habit_refs.each do |habit_ref|
        sum = sum + 1
      end
      @post_habit_reflections_count[key] = sum
    end


  end
end
