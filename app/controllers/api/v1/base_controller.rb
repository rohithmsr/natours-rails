module Api
  module V1
    class BaseController < ActionController::API
      include CurrentTravellerDetails
      before_action :snake_case_params

      def home
        welcome_message = "Hi #{traveller_name}, Welcome to the Natours API"
        render json: { message: welcome_message }
      end

    private

      def snake_case_params
        request.parameters.deep_transform_keys!(&:underscore)
      end
    end
  end
end
