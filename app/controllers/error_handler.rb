# Error module to Handle errors globally
# include Error::ErrorHandler in application_controller.rb
module Error
  module ErrorHandler
    def self.included(klass)
      klass.class_eval do
        rescue_from ActionController::UnpermittedParameters, with: :unpermitted_parameter
      end
    end

    private
    def unpermitted_parameter(error)
      message = "You have entered an unpermitted parameter: %s. " % error.params.to_sentence
      message << 'Please verify that the parameter name is valid and the values are the correct type.'
      Rails.logger.info(Rainbow(" !!! UNPERMITTED: !!! #{error.to_s}").fg(:red))

      respond_to do |format|
        format.html { redirect_back fallback_location: { action: "index" },
                                    :alert => message }
        format.json {
          render json: message
        }
      end
    end
  end
end