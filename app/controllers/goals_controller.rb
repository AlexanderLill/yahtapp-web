class GoalsController < ApplicationController
  before_action :authenticate_user!

  # action that is used for the view that creates a new goal
  def new
    @goal = Goal.new
  end

  # action that is used for the view that edits a goal
  def edit
    @goal = Goal.find(params[:id])
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
    @goal = Goal.find(params[:id])
    authorize @goal
    if @goal.update(goal_params)
      redirect_to edit_goal_path(@goal), notice: "The goal was updated successfully"
    else
      render 'edit'
    end
  end

  def destroy
    @goal = Goal.find(params[:id])
    authorize @goal
    @goal.destroy
    redirect_to dashboard_path, notice: "The goal was deleted successfully."
  end

  private

  # defines the param keys that are allowed to be set on the model
  def allowed_params
    [:title, :description, :is_template, :template_id, :user_id,]
  end

  def goal_params
    params.require(:goal).permit(*allowed_params)
  end

end