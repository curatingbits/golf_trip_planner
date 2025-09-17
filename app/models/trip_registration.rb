class TripRegistration < ApplicationRecord
  belongs_to :user
  belongs_to :trip
  belongs_to :deposit_confirmed_by, class_name: 'User', optional: true

  validates :user_id, presence: true
  validates :trip_id, presence: true
  validates :registration_date, presence: true
  validates :user_id, uniqueness: { scope: :trip_id, message: "is already registered for this trip" }

  scope :recent, -> { order(registration_date: :desc) }
  scope :with_paid_deposit, -> { where(deposit_paid: true) }
  scope :pending_deposit, -> { where(deposit_paid: false) }

  def confirm_deposit!(admin_user)
    update!(
      deposit_paid: true,
      deposit_paid_date: Time.current,
      deposit_confirmed_by: admin_user
    )
  end

  def unconfirm_deposit!
    update!(
      deposit_paid: false,
      deposit_paid_date: nil,
      deposit_confirmed_by: nil
    )
  end

  def deposit_status
    return 'N/A' unless trip.requires_deposit?
    deposit_paid? ? 'Paid' : 'Pending'
  end
end
