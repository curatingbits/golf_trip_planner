class Admin::GolfRoundsController < ApplicationController
  before_action :require_admin
  before_action :set_trip
  before_action :set_golf_round, only: [:show, :edit, :update, :destroy]

  def index
    @golf_rounds = @trip.golf_rounds.by_date.includes(:course)
  end

  def show
  end

  def new
    @golf_round = @trip.golf_rounds.build
    @golf_round.build_course if @golf_round.course.nil?
  end

  def create
    @golf_round = @trip.golf_rounds.build(golf_round_params)

    if @golf_round.save
      redirect_to admin_trip_golf_rounds_path(@trip), notice: 'Golf round was successfully created.'
    else
      render :new
    end
  end

  def edit
    @golf_round.build_course if @golf_round.course.nil?
  end

  def update
    if @golf_round.update(golf_round_params)
      redirect_to admin_trip_golf_rounds_path(@trip), notice: 'Golf round was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @golf_round.destroy
    redirect_to admin_trip_golf_rounds_path(@trip), notice: 'Golf round was successfully deleted.'
  end

  private

  def set_trip
    @trip = Trip.find(params[:trip_id])
  end

  def set_golf_round
    @golf_round = @trip.golf_rounds.find(params[:id])
  end

  def golf_round_params
    params.require(:golf_round).permit(:tee_time, :cost_per_person, :description,
                                       course_attributes: [:id, :name, :address, :par, :yardage, :rating, :slope])
  end
end