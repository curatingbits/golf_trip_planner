class ItineraryItem < ApplicationRecord
  belongs_to :trip

  validates :date, presence: true
  validates :activity_type, presence: true, inclusion: { in: %w[golf dinner activity transportation] }
  validates :title, presence: true

  scope :by_date_and_time, -> { order(:date, :start_time) }
  scope :for_date, ->(date) { where(date: date) }
  scope :golf_activities, -> { where(activity_type: 'golf') }
  scope :dinner_activities, -> { where(activity_type: 'dinner') }

  def formatted_start_time
    start_time&.strftime('%I:%M %p')
  end

  def formatted_end_time
    end_time&.strftime('%I:%M %p')
  end

  def time_range
    return formatted_start_time unless end_time

    "#{formatted_start_time} - #{formatted_end_time}"
  end
end
