class GolfRound < ApplicationRecord
  belongs_to :trip
  belongs_to :course, optional: true

  accepts_nested_attributes_for :course

  validates :tee_time, presence: true
  validates :cost_per_person, presence: true, numericality: { greater_than: 0 }

  scope :by_date, -> { order(:tee_time) }
  scope :upcoming, -> { where('tee_time >= ?', Time.current) }

  def formatted_tee_time
    tee_time.strftime('%I:%M %p')
  end

  def past?
    tee_time < Time.current
  end
end
