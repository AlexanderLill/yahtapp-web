class Api::V1::OccurrencesController < ApiController
  before_action :set_user, only: %i[ index ]

  def index
    @occurrences = @user.occurrences.includes(:habit)
  end

  def set_user
    @user = User.find(params[:user_id])
  end
end
