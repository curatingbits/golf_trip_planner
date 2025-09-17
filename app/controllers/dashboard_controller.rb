class DashboardController < ApplicationController
  def index
    @active_trips = Trip.active.upcoming
    @user_trips = current_user.trips.upcoming if current_user
    @user_room = current_user&.room_for_trip(@active_trips.first) if @active_trips.any?
  end
end
