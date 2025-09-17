class BettingPool < ApplicationRecord
  belongs_to :trip
  has_many :betting_participations, dependent: :destroy
  has_many :users, through: :betting_participations

  validates :name, presence: true
  validates :cost_per_person, presence: true, numericality: { greater_than: 0 }

  def total_pool_amount
    betting_participations.count * cost_per_person
  end

  def participants_count
    betting_participations.count
  end
end
