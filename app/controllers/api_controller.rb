class ApiController < ApplicationController
  include ApiErrors
  before_action :set_default_format, :authenticate_user!
  skip_before_action :verify_authenticity_token # CSRF token protection is not required on API endpoints
  private

  def set_default_format
    request.format = :json
  end

  def render_jsonapi_response(resource)
    if resource.errors.empty?
      render jsonapi: resource
    else
      render jsonapi_errors: resource.errors, status: 400
    end
  end

end
