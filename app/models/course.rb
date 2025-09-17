class Course < ApplicationRecord
  has_many :golf_rounds, dependent: :nullify

  validates :name, presence: true
  validates :par, numericality: { greater_than: 0 }, allow_nil: true
  validates :yardage, numericality: { greater_than: 0 }, allow_nil: true
  validates :rating, numericality: { greater_than: 0 }, allow_nil: true
  validates :slope, numericality: { greater_than: 0 }, allow_nil: true
end