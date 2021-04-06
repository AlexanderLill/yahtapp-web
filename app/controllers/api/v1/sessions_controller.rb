# Controller that handles the authentication in the API
class Api::V1::SessionsController < Devise::SessionsController
  include ApiErrors

  protect_from_forgery prepend: true
  skip_before_action :verify_authenticity_token
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.email && resource.username
      @current_token = request.env['warden-jwt_auth.token']
      render resource
    else
      head :unauthorized
    end
  end

  def respond_to_on_destroy
    head :no_content
  end

end