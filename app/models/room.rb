class Room < ApplicationRecord
  belongs_to :accommodation
  has_many :room_reservations, dependent: :destroy
  has_many :users, through: :room_reservations

  validates :name, presence: true
  validates :room_type, presence: true
  validates :capacity, presence: true, numericality: { greater_than: 0 }
  validates :cost_per_person, presence: true, numericality: { greater_than: 0 }

  scope :available, -> { joins(:room_reservations).where(room_reservations: { user_id: nil }) }

  def available?
    room_reservations.where.not(user_id: nil).count < capacity
  end

  def available_spots
    capacity - room_reservations.where.not(user_id: nil).count
  end

  def total_cost
    cost_per_person * capacity
  end

  def name
    room_number || "Room #{id}"
  end

  def beds_description
    case room_type
    when 'single'
      '1 Single Bed'
    when 'double'
      '1 Double Bed'
    when 'master'
      '1 King Bed'
    when 'guest'
      '2 Single Beds'
    when 'suite'
      '1 King Bed + Living Area'
    when 'shared'
      "#{capacity} Bunk Beds"
    else
      description || "Sleeps #{capacity}"
    end
  end

  def occupants
    users.includes(:user)
  end

  def current_occupants
    room_reservations.includes(:user).map(&:user)
  end
end
