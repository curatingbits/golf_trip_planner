class Trip < ApplicationRecord
  has_many :accommodations, dependent: :destroy
  has_many :golf_rounds, dependent: :destroy
  has_many :itinerary_items, dependent: :destroy
  has_many :betting_pools, dependent: :destroy
  has_many :trip_registrations, dependent: :destroy
  has_many :users, through: :trip_registrations

  validates :name, presence: true
  validates :location, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :total_cost, presence: true, numericality: { greater_than: 0 }
  validates :deposit_amount, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  validate :end_date_after_start_date

  scope :active, -> { where(active: true) }
  scope :upcoming, -> { where('start_date > ?', Date.current) }

  def duration_days
    (end_date - start_date).to_i + 1
  end

  def upcoming?
    start_date > Date.current
  end

  def requires_deposit?
    deposit_amount.present? && deposit_amount > 0
  end

  def users_with_paid_deposits
    trip_registrations.where(deposit_paid: true).includes(:user).map(&:user)
  end

  def users_pending_deposits
    trip_registrations.where(deposit_paid: false).includes(:user).map(&:user)
  end

  private

  def end_date_after_start_date
    return unless start_date && end_date

    errors.add(:end_date, "must be after start date") if end_date < start_date
  end
end
