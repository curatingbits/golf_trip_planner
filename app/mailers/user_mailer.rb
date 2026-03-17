class UserMailer < ApplicationMailer
  def password_reset(user)
    @user = user
    @reset_url = reset_password_url(token: @user.password_reset_token)

    mail(to: @user.email, subject: "Reset your password - Okie Cup")
  end

  def payment_request(user, trip)
    @user = user
    @trip = trip
    @registration = user.trip_registrations.find_by(trip: trip)
    room = user.room_for_trip(trip)
    @room_name = room&.name
    @room_cost = room&.cost_per_person || 0
    @deposit_credit = (@registration&.deposit_paid? && trip.requires_deposit?) ? trip.deposit_amount : 0
    @room_balance = @registration&.room_paid? ? 0 : [@room_cost - @deposit_credit, 0].max

    trip.attachments.each do |attachment|
      next unless attachment.content_type == "application/pdf"
      begin
        attachments[attachment.filename.to_s] = {
          mime_type: attachment.content_type,
          content: attachment.download
        }
      rescue ActiveStorage::FileNotFoundError
        # Skip attachments where the file is missing from storage
      end
    end

    mail(to: @user.email, subject: "Payment Request - #{trip.name}")
  end
end
