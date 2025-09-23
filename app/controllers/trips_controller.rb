class TripsController < ApplicationController
  before_action :set_trip
  before_action :require_authentication, except: [:show]

  def show
    @golf_rounds = @trip.golf_rounds.by_date
    @accommodations = @trip.accommodations.includes(:rooms)
    @betting_pools = @trip.betting_pools
    @itinerary_items = @trip.itinerary_items.by_date_and_time
    @user_room = current_user&.room_for_trip(@trip) if current_user&.registered_for_trip?(@trip)
  end

  def register
    if current_user.registered_for_trip?(@trip)
      redirect_to @trip, alert: "You are already registered for this trip."
      return
    end

    begin
      TripRegistration.create!(
        user: current_user,
        trip: @trip,
        registration_date: Time.current
      )

      redirect_to room_selection_trip_path(@trip), notice: "Successfully registered for #{@trip.name}! Please select your room."
    rescue ActiveRecord::RecordInvalid => e
      redirect_to @trip, alert: "Registration failed: #{e.record.errors.full_messages.join(', ')}"
    rescue => e
      redirect_to @trip, alert: "An error occurred during registration. Please try again."
    end
  end

  def room_selection
    redirect_to @trip, alert: "You must be registered for this trip to select a room" unless current_user.registered_for_trip?(@trip)

    @accommodations = @trip.accommodations.includes(:rooms)
    @user_room = current_user.room_for_trip(@trip)
  end

  def select_room
    @room = Room.find(params[:room_id])

    # Check if user is already in this room
    current_room = current_user.room_for_trip(@trip)
    if current_room == @room
      redirect_to trip_room_selection_path(@trip), alert: "You are already in this room."
      return
    end

    if @room.available?
      # Track if this is a room change
      is_room_change = current_room.present?
      old_room_name = current_room&.name

      # Remove any existing room reservation for this trip
      current_user.room_reservations.joins(room: { accommodation: :trip })
                   .where(trips: { id: @trip.id }).destroy_all

      # Create new reservation
      RoomReservation.create!(
        user: current_user,
        room: @room,
        reservation_date: Time.current
      )

      if is_room_change
        redirect_to @trip, notice: "Room successfully changed from #{old_room_name} to #{@room.name}!"
      else
        redirect_to @trip, notice: "Room #{@room.name} successfully reserved!"
      end
    else
      redirect_to trip_room_selection_path(@trip), alert: "Sorry, this room is no longer available."
    end
  end

  private

  def set_trip
    @trip = Trip.find(params[:id])
  end

  def require_authentication
    redirect_to login_path unless current_user
  end
end
