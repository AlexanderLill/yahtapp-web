class ApiController < ApplicationController
  include ApiErrors
  before_action :set_default_format, :authenticate_user!

  private

  def set_default_format
    request.format = :json
  end
end
