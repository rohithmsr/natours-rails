class ToursController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @tours = Tour.all
    render json: @tours
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
end