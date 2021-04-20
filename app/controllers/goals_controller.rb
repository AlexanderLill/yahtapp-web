class GoalsController < ApplicationController
  # actions that are executed before each action in this controller
  before_action :authenticate_user!
  before_action :set_goal, only: %i[ show edit update destroy ]

  layout 'boxed' # sets the layout for all views with this controller

  # GET /habits or /habits.json
  def index
    @goals = policy_scope(Goal)
  end

  def show
  end

  # action that is used for the view that creates a new goal
  def new
    @goal = current_user.goals.new
  end

  # action that is used for the view that edits a goal
  def edit
  end

  # action to create a new goal
  def create
    @goal = Goal.new(goal_params)
    authorize @goal
    if @goal.save
      redirect_to goal_path(@goal), notice: 'Goal was created successfully.'
    else
      render 'new'
    end
  end


  # action to update a goal
  def update
    authorize @goal
    if @goal.update(goal_params)
      redirect_to edit_goal_path(@goal), notice: "The goal was updated successfully"
    else
      render 'edit'
    end
  end

  def destroy
    authorize @goal
    @goal.destroy
    redirect_to dashboard_path, notice: "The goal was deleted successfully."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_goal
    @goal = Goal.find(params[:id])
  end

  # defines the param keys that are allowed to be set on the model
  def allowed_params
    [:title, :description, :is_template, :template_id, :user_id, :color]
  end

  def goal_params
    params.require(:goal).permit(*allowed_params)
  end

end