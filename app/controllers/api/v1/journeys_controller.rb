module Api
  module V1
    class JourneysController < Api::V1::BaseController
      before_action :authenticate_traveller!
      rescue_from ActiveRecord::RecordNotFound, with: :not_found

      def show
        journey = Journey.find(params[:id])
        travellers = journey.travellers

        render json: {
          journey: journey,
          travellers: {
            count: travellers.count,
            data: travellers
          }
        }
      end

      def create
        journey = Journey.new(journey_params)
        if journey.save
          render json: journey, status: :created
        else
          render json: { errors: journey.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def assign_travellers
        journey = Journey.find(params[:journey_id])
        travellers = Traveller.where(id: params[:traveller_ids])
        new_travellers = travellers.reject { |traveller| journey.travellers.include?(traveller) }
        journey.travellers << new_travellers

        if new_travellers.none?
          render json: { message: 'Travellers are already assigned / they do not exist' }, status: :unprocessable_entity
        else
          render json: { message: "Travellers successfully assigned to the journey #{journey.id}.",
                         assigned_travellers: new_travellers }, status: :created
        end
      end

      def unassign_travellers
        journey = Journey.find(params[:journey_id])
        travellers = Traveller.where(id: params[:traveller_ids])

        unassigned_travellers = travellers.merge(journey.travellers)
        journey.travellers.delete(unassigned_travellers)

        render json: {
          message: "Travellers successfully unassigned from the journey #{journey.id}.",
          unassigned_travellers: unassigned_travellers
        }, status: :ok
      end

    private

      def journey_params
        params.require(:journey).permit(:start_date, :end_date, :tour_id)
      end
    end
  end
end
