module ApiErrors
  extend ActiveSupport::Concern

  included do
    rescue_from ActionController::UnpermittedParameters, with: :unpermitted_parameter
    rescue_from ActionController::ParameterMissing, with: :parameter_missing
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
  end

  def unpermitted_parameter(exception)
    render json: { errors: [{ title: exception.message, status: '401' }] }, status: :unprocessable_entity
  end

  def parameter_missing(exception)
    errors = {}
    errors[exception.param] = ['parameter is required']
    render json: { errors: errors }, status: :unprocessable_entity
  end

  def not_found(exception)
    render json: { errors: [{ title: exception.message, status: '404' }] }, status: :not_found
  end

end