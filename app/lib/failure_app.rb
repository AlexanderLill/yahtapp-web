# Our custom failure response app since we want to return JSON:API like
# messages for some APIs.
class FailureApp < Devise::FailureApp
  def respond
    @request = request.original_fullpath
    if request.original_fullpath.starts_with?("/api")
      json_api_error_response
    else
      super
    end
  end

  def json_api_error_response
    self.status        = 401
    self.content_type  = 'application/json'
    self.response_body = { errors: [{ status: '401', title: i18n_message }]}.to_json
  end
end
