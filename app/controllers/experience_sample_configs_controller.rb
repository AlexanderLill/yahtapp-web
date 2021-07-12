class ExperienceSampleConfigsController < ApplicationController
  before_action :set_experience_sample_config, only: %i[ show edit update destroy ]

  layout 'boxed' # sets the layout for all views with this controller

  # GET /experience_sample_configs
  def index
    show = params[:show].to_s

    case show
    when "own"
      @experience_sample_configs = current_user.experience_sample_configs
    when "trash"
      @experience_sample_configs = policy_scope(ExperienceSampleConfig).only_deleted
    else
      @experience_sample_configs = policy_scope(ExperienceSampleConfig)
    end

  end

  # GET /experience_sample_configs/1
  def show
    authorize @experience_sample_config
    @current_samplings = @experience_sample_config.samplings.where('scheduled_at <= ?', DateTime.now).order(scheduled_at: :asc)
    @chart = {
      data: @current_samplings.map { |sampling| { x: sampling.scheduled_at.iso8601(3), y: sampling.value} },
      min: 1,
      max: 1 + @experience_sample_config.scale_steps-1,
      label: @experience_sample_config.title
    }
    @samplings = @experience_sample_config.samplings.where('scheduled_at >= ?', DateTime.now.beginning_of_week).order(scheduled_at: :asc).limit(50)
  end

  # GET /experience_sample_configs/new
  def new
    @experience_sample_config = ExperienceSampleConfig.new(user: current_user)
  end

  # GET /experience_sample_configs/1/edit
  def edit
    authorize @experience_sample_config
  end

  # POST /experience_sample_configs
  def create
    @experience_sample_config = ExperienceSampleConfig.new(experience_sample_config_params)

    respond_to do |format|
      if @experience_sample_config.save
        format.html { redirect_to @experience_sample_config, notice: "Self-Report config was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /experience_sample_configs/1
  def update
    authorize @experience_sample_config
    respond_to do |format|
      if @experience_sample_config.update(experience_sample_config_params)
        format.html { redirect_to @experience_sample_config, notice: "Self-Report config was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /experience_sample_configs/1
  def destroy
    authorize @experience_sample_config
    @experience_sample_config.destroy
    respond_to do |format|
      format.html { redirect_to experience_sample_configs_url, notice: "Self-Report config was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_experience_sample_config
      @experience_sample_config = ExperienceSampleConfig.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def experience_sample_config_params
      params.require(:experience_sample_config).permit(:title, :prompt, :scale_steps, :scale_label_start, :scale_label_center, :scale_label_end, :user_id, :goal_id ,:recurrence_at, :recurrence_on => [])
    end
end
