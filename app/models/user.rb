class User < ApplicationRecord
  has_secure_password

  has_many :trip_registrations, dependent: :destroy
  has_many :trips, through: :trip_registrations
  has_many :room_reservations, dependent: :destroy
  has_many :rooms, through: :room_reservations
  has_many :betting_participations, dependent: :destroy
  has_many :betting_pools, through: :betting_participations

  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :handicap, presence: true, numericality: true

  scope :admins, -> { where(admin: true) }
  scope :golfers, -> { where(admin: false) }
  scope :search, ->(term) {
    where("first_name ILIKE ? OR last_name ILIKE ? OR email ILIKE ?",
          "%#{term}%", "%#{term}%", "%#{term}%") if term.present?
  }
  scope :with_trips, -> { joins(:trips).distinct }
  scope :without_trips, -> { left_joins(:trips).where(trips: { id: nil }) }
  scope :by_name, -> { order(:last_name, :first_name) }

  def full_name
    "#{first_name} #{last_name}"
  end

  def admin?
    admin
  end

  def registered_for_trip?(trip)
    trips.include?(trip)
  end

  def room_for_trip(trip)
    return unless registered_for_trip?(trip)

    room_reservations.joins(room: { accommodation: :trip })
                     .where(trips: { id: trip.id })
                     .first&.room
  end
end
