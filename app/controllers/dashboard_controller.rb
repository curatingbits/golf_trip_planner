class DashboardController < ApplicationController
  def index
    if current_user
      # Get all active upcoming trips
      all_active_trips = Trip.active.upcoming

      # Get trips user is registered for
      @registered_trips = current_user.trips.active.upcoming

      # Get trips user can register for (not already registered)
      @available_trips = all_active_trips.where.not(id: @registered_trips.pluck(:id))

      # Get user's room for the first registered trip (for dashboard stats)
      @user_room = current_user&.room_for_trip(@registered_trips.first) if @registered_trips.any?
    else
      @registered_trips = Trip.none
      @available_trips = Trip.active.upcoming
      @user_room = nil
    end
  end
end
