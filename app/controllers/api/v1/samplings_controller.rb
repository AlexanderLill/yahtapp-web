class Api::V1::SamplingsController < ApiController
  before_action :set_user, only: %i[ index update ]
  before_action :set_sampling, only: %i[ update ]

  # TODO: make sure that user can only own samplings

  def index
    @samplings = @user.samplings.includes(:experience_sample_config)
  end

  def update
    @sampling.update!(sampling_params)
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_sampling
    @sampling = Sampling.find(params[:id])
  end

  private
  # Only allow a list of trusted parameters through.
  def sampling_params
    params.require(:sampling).permit(:sampled_at, :value)
  end
end
