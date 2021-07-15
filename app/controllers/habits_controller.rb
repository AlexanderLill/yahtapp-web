class HabitsController < ApplicationController
  before_action :set_habit, only: %i[ show edit update destroy enable disable ]
  before_action :authenticate_user!

  layout 'boxed' # sets the layout for all views with this controller

  # GET /habits or /habits.json
  def index
    show = params[:show].to_s
    case show
    when "templates"
      @habits = policy_scope(Habit).where(is_template: true)
    when "own"
      @habits = current_user.habits
    when "trash"
      @habits = policy_scope(Habit).only_deleted
    else
      @habits = policy_scope(Habit)
    end

  end

  # view for selecting a new habit (based on a template)
  def select
    @goals = Habit.where(is_template: true).where(goal: { is_template: true}).includes([:goal, :current_config]).group_by{ |habit| habit.goal_id }
  end

  # action for cloning the templates
  def clone
    @habit_ids = params[:habit_ids]

    # TODO: what to do with duplicate habits? e.g. the user already has a clone of that habit?

    # 1. get list of selected habits
    @habits = Habit.where(id:@habit_ids)

    if @habits.present?
      Habit.transaction do
        # 2. duplicate habits and habit config
        # the habits are now cloned but still have the old goals assigned to them
        new_habits = @habits.map{ |habit| habit.clone(current_user)}
        # 3. loop over all the new habits
        new_habits.each do |habit|
          # check if user already has a goal that was derived from that template
          existing_goal = current_user.goals.where(template_id: habit.goal_id).first
          if existing_goal.present?
            # change goal to existing user's goal with same template_id
            habit.update(goal: existing_goal)
          else
            new_goal = habit.goal.clone(current_user)
            habit.update(goal: new_goal)
          end
        end
      end
      redirect_to dashboard_path, notice: "Successfully created #{@habits.count} habits."
    else
      redirect_to select_habits_path, alert: "Please select at least one habit."
    end
  end

  # GET /habits/1 or /habits/1.json
  def show
    authorize @habit
    @occurrences = @habit.occurrences.order(scheduled_at: :asc)
    @configs = @habit.configs.order(created_at: :desc)
  end

  # GET /habits/new
  def new
    @habit = HabitForm.new(user: current_user)
  end

  # GET /habits/1/edit
  def edit
    authorize @habit
    session[:redirect_to] = params[:redirect_to]
  end

  # POST /habits or /habits.json
  def create
    params = habit_params
    if params[:user_id].nil? and params[:user].nil? and !policy(@habit).set_user?
      params[:user] = current_user
    end

    @habit = HabitForm.new(params)

    respond_to do |format|
      if @habit.save
        format.html { redirect_to @habit, notice: "Habit was successfully created." }
        format.json { render :show, status: :created, location: @habit }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @habit.errors, status: :unprocessable_entity }
      end
    end
  end


  def disable
    authorize @habit

    unless @habit.is_enabled
      redirect_to @habit_path, alert: "Habit is already disabled."
    end

    @habit_path = habit_path(@habit.id)
    return_to = params[:redirect_to].to_s.present? ? params[:redirect_to].to_s : @habit_path

    if @habit.disable
      redirect_to return_to, notice: "Habit was successfully disabled."
    else
      redirect_to @habit_path, alert: "Habit could not be disabled."
    end
  end

  def enable
    authorize @habit

    if @habit.is_enabled
      redirect_to @habit_path, alert: "Habit is already enabled."
    end

    @habit_path = habit_path(@habit.id)
    return_to = params[:redirect_to].to_s.present? ? params[:redirect_to].to_s : @habit_path

    if @habit.enable
      redirect_to return_to, notice: "Habit was successfully enabled."
    else
      redirect_to @habit_path, alert: "Habit could not be enabled."
    end
  end

  # PATCH/PUT /habits/1 or /habits/1.json
  def update
    authorize @habit
    @habit_form = HabitForm.new(habit_params.merge("id" => params[:id]))
    @habit_path = habit_path(@habit_form.id)
    return_to = session[:redirect_to].to_s.present? ? session[:redirect_to].to_s : @habit_path
    session[:redirect_to] = nil
    if @habit_form.update(habit_params)
      redirect_to return_to, notice: "Habit was successfully updated."
    else
      render @habit_path, status: :unprocessable_entity
    end
  end

  # DELETE /habits/1 or /habits/1.json
  def destroy
    authorize @habit
    message = @habit.deleted_at.present? ? "Habit was successfully destroyed." : "Habit was put in trash."
    @habit.destroy
    redirect_to habits_url, notice: message
  end

  def set_recurrence_from_param
    type = habit_params[:recurrence_type] # :week, :day
    on = habit_params[:recurrence_on]
    at = habit_params[:recurrence_at]
    @habit.add_recurrence(type: type, on: on, at: at)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_habit
      @habit = Habit.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def habit_params
      params.require(:habit).permit(:title, :description, :goal_id, :user_id, :recurrence_type, :duration, :is_template, :is_skippable, :is_enabled, :type,:recurrence_at, :recurrence_on => [])
    end
end
