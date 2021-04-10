class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @goals = current_user.goals
  end
end
