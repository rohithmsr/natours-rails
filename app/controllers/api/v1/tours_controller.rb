module Api
  module V1
    class ToursController < Api::V1::BaseController
      def index
        query = Api::Queries::Tours.new(index_params)
        tours = query.records

        render json: { tours: tours, result_count: query.count }
      end

      def show
        @tour = Tour.find(params[:id])
        render json: @tour
      end

      def create
        @tour = Tour.new(tour_params)
        if @tour.save
          redirect_to @tour
        else
          render json: { errors: @tour.errors.full_messages }
        end
      end

      def update
        @tour = Tour.find(params[:id])
        if @tour.update(tour_params)
          redirect_to @tour
        else
          render json: { errors: @tour.errors.full_messages }
        end
      end

      def destroy
        @tour = Tour.find(params[:id])
        @tour.destroy

        redirect_to tours_path, notice: "Tour #{params[:id]} deleted"
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
    end
  end
end