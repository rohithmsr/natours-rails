module Api
  module V1
    class BaseController < ActionController::API
      before_action :snake_case_params

      private

      def snake_case_params
        request.parameters.deep_transform_keys!(&:underscore)
      end
    end
  end
end
