module Api
  module V1
    class OrdersController < Api::V1::BaseController
      before_action :authenticate_traveller!
      rescue_from ActiveRecord::RecordNotFound, with: :not_found

      def show
        order = Order.find(params[:id])
        render json: order
      end

      def create
        order = Order.new(order_create_params.merge(traveller_id: current_traveller.id))
        if order.save
          render json: order, status: :created
        else
          render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        order = Order.find(params[:id])
        if order.update(order_update_params)
          render json: { order: order }
        else
          render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
        end
      end

    private

      def order_create_params
        params.require(:order).permit(:journey_id, :amount, :payment_done, :travel_status)
      end

      def order_update_params
        params.require(:order).permit(:travel_status)
      end
    end
  end
end
