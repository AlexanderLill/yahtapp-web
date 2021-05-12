class ExperimentationController < ApplicationController
  before_action :authenticate_user!
  layout 'boxed' # sets the layout for all views with this controller
  def index
  end
end
