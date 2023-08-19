module Api
  module V1
    class TravellersController < Api::V1::BaseController
      before_action :authenticate_traveller!
      rescue_from ActiveRecord::RecordNotFound, with: :not_found

      def show
        traveller = Traveller.find(params[:id])
        render json: traveller
      end

      def deactivate
        traveller = Traveller.find(params[:traveller_id])

        if traveller.status == 'inactive'
          render json: { error: 'Traveller Account is already inactive' }, status: :unprocessable_entity
        elsif traveller.update(status: 'inactive')
          render json: { traveller: traveller }
        else
          render json: { errors: traveller.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def reactivate
        traveller = Traveller.find(params[:traveller_id])

        if traveller.status == 'active'
          render json: { error: 'Traveller Account is already active' }, status: :unprocessable_entity
        elsif traveller.update(status: 'active')
          render json: { traveller: traveller }
        else
          render json: { errors: traveller.errors.full_messages }, status: :unprocessable_entity
        end
      end

    private

      def not_found(message)
        render json: { error: message }, status: :not_found
      end
    end
  end
end
