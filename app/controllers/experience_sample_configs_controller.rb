class ExperienceSampleConfigsController < ApplicationController
  before_action :set_experience_sample_config, only: %i[ show edit update destroy ]

  layout 'boxed' # sets the layout for all views with this controller

  # GET /experience_sample_configs or /experience_sample_configs.json
  def index
    @experience_sample_configs = ExperienceSampleConfig.all
  end

  # GET /experience_sample_configs/1 or /experience_sample_configs/1.json
  def show
    @samplings = @experience_sample_config.samplings.order(scheduled_at: :asc)
  end

  # GET /experience_sample_configs/new
  def new
    @experience_sample_config = ExperienceSampleConfig.new(user: current_user)
  end

  # GET /experience_sample_configs/1/edit
  def edit
  end

  # POST /experience_sample_configs or /experience_sample_configs.json
  def create
    @experience_sample_config = ExperienceSampleConfig.new(experience_sample_config_params)

    respond_to do |format|
      if @experience_sample_config.save
        format.html { redirect_to @experience_sample_config, notice: "Experience sample config was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /experience_sample_configs/1 or /experience_sample_configs/1.json
  def update
    respond_to do |format|
      if @experience_sample_config.update(experience_sample_config_params)
        format.html { redirect_to @experience_sample_config, notice: "Experience sample config was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /experience_sample_configs/1 or /experience_sample_configs/1.json
  def destroy
    @experience_sample_config.destroy
    respond_to do |format|
      format.html { redirect_to experience_sample_configs_url, notice: "Experience sample config was successfully destroyed." }
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
      params.require(:experience_sample_config).permit(:title, :prompt, :scale_steps, :scale_label_start, :scale_label_center, :scale_label_end, :user_id ,:recurrence_at, :recurrence_on => [])
    end
end
