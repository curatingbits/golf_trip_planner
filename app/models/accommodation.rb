class Accommodation < ApplicationRecord
  belongs_to :trip
  has_many :rooms, dependent: :destroy

  validates :name, presence: true
  validates :accommodation_type, presence: true, inclusion: { in: %w[house hotel] }

  scope :houses, -> { where(accommodation_type: 'house') }
  scope :hotels, -> { where(accommodation_type: 'hotel') }

  def house?
    accommodation_type == 'house'
  end

  def hotel?
    accommodation_type == 'hotel'
  end
end
