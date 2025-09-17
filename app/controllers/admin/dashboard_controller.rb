class Admin::DashboardController < ApplicationController
  before_action :require_admin

  def index
    @trips_count = Trip.count
    @active_trips_count = Trip.active.count
    @users_count = User.count
    @admin_users_count = User.admins.count
    @recent_registrations = TripRegistration.includes(:user, :trip).recent.limit(5)
    @recent_trips = Trip.order(created_at: :desc).limit(3)
    @upcoming_trips = Trip.upcoming.limit(3)
  end
end
