class Admin::TripsController < ApplicationController
  before_action :require_admin
  before_action :set_trip, only: [:show, :edit, :update, :destroy, :confirm_deposit, :unconfirm_deposit, :unregister_user, :remove_attachment]

  def index
    @trips = Trip.order(created_at: :desc).includes(:users, :accommodations, :golf_rounds)
  end

  def show
    @accommodations = @trip.accommodations.includes(:rooms)
    @golf_rounds = @trip.golf_rounds.by_date
    @betting_pools = @trip.betting_pools
    @registered_users = @trip.users.order(:first_name)
    @trip_registrations = @trip.trip_registrations.includes(:user, :deposit_confirmed_by).order('users.first_name')
  end

  def new
    @trip = Trip.new
  end

  def create
    @trip = Trip.new(trip_params)

    if @trip.save
      redirect_to admin_trip_path(@trip), notice: 'Trip was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @trip.update(trip_params)
      redirect_to admin_trip_path(@trip), notice: 'Trip was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @trip.destroy
    redirect_to admin_trips_path, notice: 'Trip was successfully deleted.'
  end

  def confirm_deposit
    registration = @trip.trip_registrations.find(params[:registration_id])
    registration.confirm_deposit!(current_user)
    redirect_to admin_trip_path(@trip), notice: "Deposit confirmed for #{registration.user.full_name}."
  end

  def unconfirm_deposit
    registration = @trip.trip_registrations.find(params[:registration_id])
    registration.unconfirm_deposit!
    redirect_to admin_trip_path(@trip), notice: "Deposit unconfirmed for #{registration.user.full_name}."
  end

  def remove_attachment
    attachment = @trip.attachments.find(params[:attachment_id])
    attachment.purge
    redirect_to edit_admin_trip_path(@trip), notice: "Attachment removed."
  end

  def unregister_user
    registration = @trip.trip_registrations.find(params[:registration_id])
    user = registration.user

    # Remove room reservation if any
    user.room_reservations.joins(room: { accommodation: :trip })
        .where(trips: { id: @trip.id }).destroy_all

    # Remove betting pool participations
    user.betting_participations.joins(betting_pool: :trip)
        .where(trips: { id: @trip.id }).destroy_all

    # Remove trip registration
    registration.destroy

    redirect_to admin_trip_path(@trip), notice: "#{user.full_name} has been unregistered from the trip."
  end

  private

  def set_trip
    @trip = Trip.find(params[:id])
  end

  def trip_params
    params.require(:trip).permit(:name, :location, :start_date, :end_date, :total_cost, :deposit_amount, :description, :active, attachments: [])
  end
end
