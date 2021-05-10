class ReflectionsController < ApplicationController
  before_action :set_reflection, only: %i[ show edit update destroy ]
  layout 'boxed'

  # GET /reflections or /reflections.json
  def index
    @reflections = policy_scope(Reflection).order(created_at: :desc)
  end

  # GET /reflections/1 or /reflections/1.json
  def show
  end

  # GET /reflections/new
  def new
    @reflection = Reflection.new(user: current_user)
    @reflection.habit_reflections.build()
    # TODO: find all occurrences between this and last reflection
    occs = current_user.occurrences.includes(habit: :goal)
                       .where('scheduled_at <= ?', DateTime.now).order(:scheduled_at)

    # group by goal
    @goals = occs.map{ |occ| occ.habit }.uniq.map{ |habit| HabitReflection.new(habit: habit) }.group_by{ |ref| ref.habit.goal_id }
  end

  # GET /reflections/1/edit
  def edit
    # TODO: find all occurrences between this and last reflection
    occs = current_user.occurrences.includes(habit: :goal)
                       .where('scheduled_at <= ?', DateTime.now).order(:scheduled_at)

    # group by goal
    @goals = occs.map{ |occ| occ.habit }.uniq.map{ |habit| HabitReflection.new(habit: habit) }.group_by{ |ref| ref.habit.goal_id }
  end

  # POST /reflections or /reflections.json
  def create
    @reflection = Reflection.new(reflection_params)

    respond_to do |format|
      if @reflection.save
        format.html { redirect_to @reflection, notice: "Reflection was successfully created." }
        format.json { render :show, status: :created, location: @reflection }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @reflection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reflections/1 or /reflections/1.json
  def update
    respond_to do |format|
      if @reflection.update(reflection_params)
        format.html { redirect_to @reflection, notice: "Reflection was successfully updated." }
        format.json { render :show, status: :ok, location: @reflection }
      else
        format.html { render @reflection, status: :unprocessable_entity }
        format.json { render json: @reflection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reflections/1 or /reflections/1.json
  def destroy
    @reflection.destroy
    respond_to do |format|
      format.html { redirect_to reflections_url, notice: "Reflection was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reflection
      @reflection = Reflection.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def reflection_params
      params.require(:reflection).permit(:user_id, :description, habit_reflections_attributes: [:habit_id, :rating])
    end
end
