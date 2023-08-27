module Api
  module V1
    class JourneysController < Api::V1::BaseController
      before_action :authenticate_traveller!
      rescue_from ActiveRecord::RecordNotFound, with: :not_found

      def show
        journey = Journey.find(params[:id])
        render json: journey
      end

      def create
        journey = Journey.new(journey_params)
        if journey.save
          render json: journey, status: :created
        else
          render json: { errors: journey.errors.full_messages }, status: :unprocessable_entity
        end
      end

    private

      def journey_params
        params.require(:journey).permit(:start_date, :end_date, :tour_id)
      end
    end
  end
end
