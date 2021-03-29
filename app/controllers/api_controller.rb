class ApiController < ApplicationController
  before_action :set_default_format
  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::ParameterMissing, with: :param_missing

  def param_missing
    render json: {
      'errors': [
        {
          'status': '404',
          'title': 'Parameter'
        }
      ]
    }, status: 404
  end

  def not_found(exception)
    render json: {
      'errors': [
        {
          'status': '422',
          'title': "Param '#{exception.param}' is missing or empty."
        }
      ]
    }, status: 422
  end


  private
  def set_default_format
    request.format = :json
  end
end
