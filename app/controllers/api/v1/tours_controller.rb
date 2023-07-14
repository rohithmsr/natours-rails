module Api
  module V1
    class ToursController < Api::V1::BaseController
      rescue_from ActiveRecord::RecordNotFound, with: :not_found

      def index
        query = Api::Queries::Tours.new(index_params)
        tours = query.records

        render json: { tours: tours, result_count: query.count }
      end

      def show
        tour = Tour.find(params[:id])
        render json: tour
      end

      def create
        tour = Tour.new(tour_params)
        if tour.save
          render json: tour, status: :created
        else
          render json: { errors: tour.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        tour = Tour.find(params[:id])
        if tour.update(tour_params)
          render json: { tour: tour }
        else
          render json: { errors: tour.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        tour = Tour.find(params[:id])
        tour.destroy!

        head :no_content
      end

      private

        def tour_params
          params.require(:tour).permit(:name, :key, :rating, :duration, :difficulty, :price, :price_discount, :description)
        end

        def index_params
          params.permit(
            :page,
            :limit
          )
        end

        def not_found(message)
          render json: { error: message }, status: :not_found
        end
    end
  end
end