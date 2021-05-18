class ExperimentationController < ApplicationController
  before_action :authenticate_user!
  layout 'boxed' # sets the layout for all views with this controller

  def index
    param_start = params[:start].to_s
    @start_datetime = DateTime.parse(param_start)
    @first_reflection_at = current_user.occurrences.order('scheduled_at').first.scheduled_at

    @has_data_before_start_date = @start_datetime > @first_reflection_at

    pre_reflections = current_user.habit_reflections.includes(habit: :goal)
                                  .where('habit_reflections.created_at < ?', @start_datetime).order('habit_reflections.created_at')

    post_reflections = current_user.habit_reflections.includes(habit: :goal)
                                  .where('habit_reflections.created_at >= ?', @start_datetime).order('habit_reflections.created_at')

    pre_occurrences = current_user.occurrences.where('scheduled_at < ?', @start_datetime)
    post_occurrences = current_user.occurrences.where('scheduled_at >= ?', @start_datetime)

    pre_habit_occurrences = pre_occurrences.group_by { |occ| occ.habit.id }
    post_habit_occurrences = post_occurrences.group_by { |occ| occ.habit.id }

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
        sum += 1
      end
      @pre_habit_reflections_count[key] = sum
    end

    @post_habit_reflections_count = {}
    post_habit_reflections.each do |key, habit_refs|
      sum = 0
      habit_refs.each do |habit_ref|
        sum += 1
      end
      @post_habit_reflections_count[key] = sum
    end

    @pre_habit_occurrences_completed = {}
    @pre_habit_occurrences_not_completed = {}
    pre_habit_occurrences.each do |key, habit_occs|
      @pre_habit_occurrences_completed[key] = 0
      @pre_habit_occurrences_not_completed[key] = 0

      habit_occs.each do |habit_occ|
        if habit_occ.started_at.present? && habit_occ.ended_at.present?
          @pre_habit_occurrences_completed[key] += 1
        else
          @pre_habit_occurrences_not_completed[key] += 1
        end
      end
    end

    @post_habit_occurrences_completed = {}
    @post_habit_occurrences_not_completed = {}
    post_habit_occurrences.each do |key, habit_occs|
      @post_habit_occurrences_completed[key] = 0
      @post_habit_occurrences_not_completed[key] = 0

      habit_occs.each do |habit_occ|
        if habit_occ.started_at.present? && habit_occ.ended_at.present?
          @post_habit_occurrences_completed[key] += 1
        else
          @post_habit_occurrences_not_completed[key] += 1
        end
      end
    end
  end
end
