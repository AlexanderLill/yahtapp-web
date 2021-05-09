class Api::V1::OccurrencesController < ApiController
  before_action :set_user, only: %i[ index update ]
  before_action :set_occurrence, only: %i[ update ]

  # TODO: make sure that user can only own occurrences

  def index
    @occurrences = @user.occurrences.includes(:habit)
  end

  def update
    @occurrence.update!(occurrence_params)
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_occurrence
    @occurrence = Occurrence.find(params[:id])
  end

  private
  # Only allow a list of trusted parameters through.
  def occurrence_params
    params.require(:occurrence).permit(:started_at, :ended_at, :skipped_at)
  end
end
