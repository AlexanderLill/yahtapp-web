class HabitsController < ApplicationController
  before_action :set_habit, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  layout 'boxed' # sets the layout for all views with this controller

  # GET /habits or /habits.json
  def index
    @habits = policy_scope(Habit)
  end

  # GET /habits/1 or /habits/1.json
  def show
    @occurrences = @habit.occurrences.order(scheduled_at: :asc)
    @configs = @habit.configs.order(created_at: :desc)
  end

  # GET /habits/new
  def new
    @habit = HabitForm.new(user: current_user)
  end

  # GET /habits/1/edit
  def edit
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

  # PATCH/PUT /habits/1 or /habits/1.json
  def update
    @habit = HabitForm.new(habit_params.merge("id" => params[:id]))
    respond_to do |format|
      if @habit.update(habit_params)
        format.html { redirect_to @habit, notice: "Habit was successfully updated." }
        format.json { render :show, status: :ok, location: @habit }
      else
        format.html { render @habit, status: :unprocessable_entity }
        format.json { render json: @habit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /habits/1 or /habits/1.json
  def destroy
    @habit.destroy
    respond_to do |format|
      format.html { redirect_to habits_url, notice: "Habit was successfully destroyed." }
      format.json { head :no_content }
    end
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
      params.require(:habit).permit(:title, :goal_id, :user_id, :recurrence_type, :duration, :is_template, :is_skippable, :type,:recurrence_at, :recurrence_on => [])
    end
end
