class Admin::AccommodationsController < ApplicationController
  before_action :require_admin
  before_action :set_trip
  before_action :set_accommodation, only: [:show, :edit, :update, :destroy]

  def index
    @accommodations = @trip.accommodations.includes(:rooms)
  end

  def show
    @rooms = @accommodation.rooms.order(:room_number)
  end

  def new
    @accommodation = @trip.accommodations.build
  end

  def create
    @accommodation = @trip.accommodations.build(accommodation_params)

    if @accommodation.save
      redirect_to admin_trip_accommodation_path(@trip, @accommodation), notice: 'Accommodation was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @accommodation.update(accommodation_params)
      redirect_to admin_trip_accommodation_path(@trip, @accommodation), notice: 'Accommodation was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @accommodation.destroy
    redirect_to admin_trip_path(@trip), notice: 'Accommodation was successfully deleted.'
  end

  private

  def set_trip
    @trip = Trip.find(params[:trip_id])
  end

  def set_accommodation
    @accommodation = @trip.accommodations.find(params[:id])
  end

  def accommodation_params
    params.require(:accommodation).permit(:name, :accommodation_type, :address, :check_in_date, :check_out_date, :total_cost, :description)
  end
end