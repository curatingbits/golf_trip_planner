class RoomReservation < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :user_id, presence: true
  validates :room_id, presence: true
  validates :reservation_date, presence: true
  validates :user_id, uniqueness: { scope: :room_id, message: "has already reserved this room" }

  validate :room_has_capacity

  scope :recent, -> { order(reservation_date: :desc) }

  private

  def room_has_capacity
    return unless room

    current_reservations = room.room_reservations.where.not(id: id).count
    errors.add(:room, "is at capacity") if current_reservations >= room.capacity
  end
end
