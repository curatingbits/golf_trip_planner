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
    Rails.logger.debug "CREATE ACTION STARTED - Params: #{params.inspect}"
    Rails.logger.debug "Current User: #{current_user&.id}, Admin: #{current_user&.admin?}"

    @betting_pool = @trip.betting_pools.build(betting_pool_params)

    Rails.logger.debug "BettingPool params: #{betting_pool_params.inspect}"
    Rails.logger.debug "BettingPool valid?: #{@betting_pool.valid?}"
    Rails.logger.debug "BettingPool errors: #{@betting_pool.errors.full_messages}"

    if @betting_pool.save
      Rails.logger.debug "BettingPool SAVE SUCCESS - ID: #{@betting_pool.id}"
      redirect_to admin_trip_betting_pools_path(@trip), notice: 'Betting pool was successfully created.'
    else
      Rails.logger.debug "BettingPool save failed. Errors: #{@betting_pool.errors.full_messages}"
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