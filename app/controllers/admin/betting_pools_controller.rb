class Admin::BettingPoolsController < ApplicationController
  before_action :require_admin
  before_action :set_trip
  before_action :set_betting_pool, only: [:show, :edit, :update, :destroy]

  def index
    @betting_pools = @trip.betting_pools.includes(:betting_participations)
  end

  def show
    @participations = @betting_pool.betting_participations.includes(:user)
  end

  def new
    @betting_pool = @trip.betting_pools.build
  end

  def create
    @betting_pool = @trip.betting_pools.build(betting_pool_params)

    if @betting_pool.save
      redirect_to admin_trip_betting_pools_path(@trip), notice: 'Betting pool was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @betting_pool.update(betting_pool_params)
      redirect_to admin_trip_betting_pools_path(@trip), notice: 'Betting pool was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @betting_pool.destroy
    redirect_to admin_trip_betting_pools_path(@trip), notice: 'Betting pool was successfully deleted.'
  end

  private

  def set_trip
    @trip = Trip.find(params[:trip_id])
  end

  def set_betting_pool
    @betting_pool = @trip.betting_pools.find(params[:id])
  end

  def betting_pool_params
    params.require(:betting_pool).permit(:name, :pool_type, :entry_fee, :description, :active)
  end
end