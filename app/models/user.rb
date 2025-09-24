class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar

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

  validate :avatar_validation, if: -> { avatar.attached? }

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

  def avatar_url(size: 200)
    if avatar.attached? && persisted?
      begin
        Rails.application.routes.url_helpers.rails_blob_url(
          avatar.variant(resize_to_fill: [size, size]), only_path: true
        )
      rescue
        # Fallback to default avatar if there's an error generating the URL
        default_avatar_url(size: size)
      end
    else
      default_avatar_url(size: size)
    end
  end

  def default_avatar_url(size: 200)
    # Generate a default avatar using the user's initials
    "https://ui-avatars.com/api/?name=#{first_name}+#{last_name}&size=#{size}&background=3b82f6&color=ffffff&bold=true"
  end

  private

  def avatar_validation
    return unless avatar.attached?

    # Check content type
    unless avatar.content_type.in?(%w[image/jpeg image/jpg image/png image/webp image/heic image/heif])
      errors.add(:avatar, "must be a JPEG, PNG, WebP, or HEIC image")
    end

    # Check file size (10MB limit)
    if avatar.byte_size > 10.megabytes
      errors.add(:avatar, "must be less than 10MB")
    end
  end
end
