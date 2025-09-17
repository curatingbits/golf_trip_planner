class Admin::RoomsController < ApplicationController
  before_action :require_admin
  before_action :set_trip_and_accommodation
  before_action :set_room, only: [:show, :edit, :update, :destroy]

  def index
    @rooms = @accommodation.rooms.order(:room_number)
  end

  def show
    @reservations = @room.room_reservations.includes(:user)
  end

  def new
    @room = @accommodation.rooms.build
  end

  def create
    @room = @accommodation.rooms.build(room_params)

    if @room.save
      redirect_to admin_trip_accommodation_path(@trip, @accommodation), notice: 'Room was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @room.update(room_params)
      redirect_to admin_trip_accommodation_path(@trip, @accommodation), notice: 'Room was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @room.destroy
    redirect_to admin_trip_accommodation_path(@trip, @accommodation), notice: 'Room was successfully deleted.'
  end

  private

  def set_trip_and_accommodation
    @trip = Trip.find(params[:trip_id])
    @accommodation = @trip.accommodations.find(params[:accommodation_id])
  end

  def set_room
    @room = @accommodation.rooms.find(params[:id])
  end

  def room_params
    params.require(:room).permit(:room_number, :room_type, :capacity, :cost_per_person, :description)
  end
end