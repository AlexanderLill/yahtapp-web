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
  end

  # GET /habits/new
  def new
    @habit = current_user.habits.new
  end

  # GET /habits/1/edit
  def edit
  end

  # POST /habits or /habits.json
  def create
    @habit = Habit.new(habit_params)

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
    respond_to do |format|
      if @habit.update(habit_params)
        format.html { redirect_to @habit, notice: "Habit was successfully updated." }
        format.json { render :show, status: :ok, location: @habit }
      else
        format.html { render :edit, status: :unprocessable_entity }
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

  def get_recurrence_from_param
    frequency = habit_params[:recurrence_frequency] # :weekly, :daily
    day_of_week = habit_params[:recurrence_day_of_week]
    at = habit_params[:recurrence_at]
    # todo: find out if we can combine multiple Montrose.daily.at("12pm")
    # todo find a way to
    if frequency == :weekly
      Montrose.daily.day_of_week(:monday, :tuesday)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_habit
      @habit = Habit.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def habit_params
      params.require(:habit).permit(:title, :goal_id, :user_id, :recurrence_frequency, :recurrence_at, :duration, :is_template, :is_skippable, :type)
    end
end
