class Admin::UsersController < ApplicationController
  before_action :require_admin
  before_action :set_user, only: [:show, :edit, :update, :destroy, :assign_trip, :edit_room, :update_room]

  def index
    @users = User.all

    # Search functionality
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @users = @users.where("first_name ILIKE ? OR last_name ILIKE ? OR email ILIKE ?",
                            search_term, search_term, search_term)
    end

    # Filter by admin status
    if params[:admin_filter].present?
      @users = @users.where(admin: params[:admin_filter] == "true")
    end

    # Filter by trip
    if params[:trip_id].present?
      @users = @users.joins(:trips).where(trips: { id: params[:trip_id] })
    end

    @users = @users.order(:last_name, :first_name)
    @trips = Trip.all.order(:name)
  end

  def show
    @user_trips = @user.trips.includes(:accommodations, :golf_rounds, :betting_pools)
    @available_trips = Trip.where.not(id: @user_trips.pluck(:id)).order(:name)
    @room_reservations = @user.room_reservations.includes(room: { accommodation: :trip })
    @user_betting_pool_ids = @user.betting_participations.pluck(:betting_pool_id).to_set
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_user_path(@user), notice: "User successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @trips = Trip.all.order(:name)
  end

  def update
    # Prevent removing own admin status
    if @user == current_user && params[:user][:admin] == "0"
      redirect_to admin_user_path(@user), alert: "You cannot remove your own admin status."
      return
    end

    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "User successfully updated."
    else
      @trips = Trip.all.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user == current_user
      redirect_to admin_users_path, alert: "You cannot delete your own account."
      return
    end

    @user.destroy
    redirect_to admin_users_path, notice: "User successfully deleted."
  end

  # Custom action to assign user to trip
  def assign_trip
    trip = Trip.find(params[:trip_id])

    if @user.trips.include?(trip)
      redirect_to admin_user_path(@user), alert: "User is already registered for this trip."
    else
      TripRegistration.create!(user: @user, trip: trip, registration_date: Time.current)
      redirect_to admin_user_path(@user), notice: "User successfully assigned to #{trip.name}."
    end
  end

  # Custom action to remove user from trip
  def remove_from_trip
    @user = User.find(params[:id])
    trip = Trip.find(params[:trip_id])

    registration = @user.trip_registrations.find_by(trip: trip)
    if registration
      registration.destroy
      redirect_to admin_user_path(@user), notice: "User removed from #{trip.name}."
    else
      redirect_to admin_user_path(@user), alert: "User is not registered for this trip."
    end
  end

  # Show room assignment page for admin
  def edit_room
    @user_trips = @user.trips.includes(:accommodations).order(:start_date)
    @selected_trip_id = params[:trip_id]
  end

  # Custom action to update room assignment
  def update_room
    unless params[:room_id].present?
      redirect_to admin_user_path(@user), alert: "Please select a room."
      return
    end

    unless params[:trip_id].present?
      redirect_to admin_user_path(@user), alert: "Trip information is missing."
      return
    end

    begin
      room = Room.find(params[:room_id])
      trip = Trip.find(params[:trip_id])

      # Verify room belongs to the specified trip
      unless room.accommodation.trip_id == trip.id
        redirect_to admin_user_path(@user), alert: "Selected room does not belong to the specified trip."
        return
      end

      unless @user.registered_for_trip?(trip)
        redirect_to admin_user_path(@user), alert: "User must be registered for the trip first."
        return
      end

      # Remove existing room reservation for this trip
      existing_reservations = @user.room_reservations.joins(room: { accommodation: :trip })
                                   .where(trips: { id: trip.id })
      existing_reservations.destroy_all

      # Create new reservation if room has capacity
      if room.available?
        RoomReservation.create!(user: @user, room: room, reservation_date: Time.current)
        redirect_to admin_user_path(@user), notice: "Room assignment updated successfully to #{room.name}."
      else
        redirect_to admin_user_path(@user), alert: "Room #{room.name} is at full capacity (#{room.current_occupants.count}/#{room.capacity})."
      end
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_user_path(@user), alert: "Selected room not found."
    rescue => e
      redirect_to admin_user_path(@user), alert: "Error updating room assignment: #{e.message}"
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :handicap, :admin, :password, :password_confirmation)
  end
end