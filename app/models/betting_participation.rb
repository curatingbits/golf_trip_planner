class BettingParticipation < ApplicationRecord
  belongs_to :user
  belongs_to :betting_pool

  validates :user_id, presence: true
  validates :betting_pool_id, presence: true
  validates :joined_at, presence: true
  validates :user_id, uniqueness: { scope: :betting_pool_id, message: "is already participating in this betting pool" }

  scope :recent, -> { order(joined_at: :desc) }
end
