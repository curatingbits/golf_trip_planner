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

  def itinerary(user, trip)
    @user = user
    @trip = trip
    @room = user.room_for_trip(trip)
    @roommates = @room&.room_reservations&.includes(:user)&.map { |rr| rr.user }&.reject { |u| u == user } || []
    @golf_rounds = trip.golf_rounds.includes(:course).order(:tee_time)
    @accommodation = trip.accommodations.first

    @events = build_itinerary_events(trip)
    @events.each { |e| e[:calendar_url] = google_calendar_url(e) }

    trip.attachments.each do |attachment|
      next unless attachment.content_type == "application/pdf"
      begin
        attachments[attachment.filename.to_s] = {
          mime_type: attachment.content_type,
          content: attachment.download
        }
      rescue ActiveStorage::FileNotFoundError
      end
    end

    attachments["okie-cup-2026.ics"] = {
      mime_type: "text/calendar",
      content: generate_ics(@events)
    }

    mail(to: @user.email, subject: "Trip Itinerary - #{trip.name}")
  end

  private

  def build_itinerary_events(trip)
    events = []

    # Wednesday dinners
    events << { title: "Team Rusty Dinner — The Mission Kierland", location: "The Mission Kierland, Scottsdale, AZ",
                start_time: Time.utc(2026, 3, 25, 18, 0), end_time: Time.utc(2026, 3, 25, 20, 0) }
    events << { title: "Team LT Dinner — Buck & Rider North", location: "Buck & Rider North, Scottsdale, AZ",
                start_time: Time.utc(2026, 3, 25, 18, 0), end_time: Time.utc(2026, 3, 25, 20, 0) }
    events << { title: "DraftKings Sports Bar", location: "DraftKings Sports Bar, Scottsdale, AZ",
                start_time: Time.utc(2026, 3, 25, 20, 0), end_time: Time.utc(2026, 3, 25, 23, 0) }

    # Thursday party bus
    events << { title: "Party Bus Pickup — Quintero Golf Club", location: @accommodation&.name.to_s + ", Scottsdale, AZ",
                start_time: Time.utc(2026, 3, 26, 8, 15), end_time: Time.utc(2026, 3, 26, 9, 30),
                description: "Party bus to Quintero Golf Club" }

    # Golf rounds
    trip.golf_rounds.includes(:course).order(:tee_time).each_with_index do |gr, i|
      events << { title: "Okie Cup Round #{i + 1} — #{gr.course.name}", location: gr.course.address,
                  start_time: gr.tee_time, end_time: gr.tee_time + 5.hours,
                  description: "Par #{gr.course.par} · #{gr.course.yardage} yards · Slope #{gr.course.slope}" }
    end

    # Thursday dinner
    events << { title: "Okie Cup Dinner — Hamburgers at the Casa", location: @accommodation&.name.to_s + ", Scottsdale, AZ",
                start_time: Time.utc(2026, 3, 26, 18, 0), end_time: Time.utc(2026, 3, 26, 20, 0) }

    events
  end

  def google_calendar_url(event)
    start_str = event[:start_time].strftime("%Y%m%dT%H%M%S")
    end_str = event[:end_time].strftime("%Y%m%dT%H%M%S")
    params = {
      action: "TEMPLATE",
      text: event[:title],
      dates: "#{start_str}/#{end_str}",
      location: event[:location] || "",
      details: event[:description] || "",
      ctz: "America/Phoenix"
    }
    "https://calendar.google.com/calendar/render?" + params.to_query
  end

  def generate_ics(events)
    lines = ["BEGIN:VCALENDAR", "VERSION:2.0", "PRODID:-//Okie Cup//Golf Trip//EN", "CALSCALE:GREGORIAN"]
    events.each do |event|
      start_str = event[:start_time].strftime("%Y%m%dT%H%M%S")
      end_str = event[:end_time].strftime("%Y%m%dT%H%M%S")
      lines += [
        "BEGIN:VEVENT",
        "DTSTART;TZID=America/Phoenix:#{start_str}",
        "DTEND;TZID=America/Phoenix:#{end_str}",
        "SUMMARY:#{ics_escape(event[:title])}",
        "LOCATION:#{ics_escape(event[:location] || "")}",
        "DESCRIPTION:#{ics_escape(event[:description] || "")}",
        "END:VEVENT"
      ]
    end
    lines << "END:VCALENDAR"
    lines.join("\r\n")
  end

  def ics_escape(text)
    text.to_s.gsub("\\", "\\\\").gsub(",", "\\,").gsub(";", "\\;").gsub("\n", "\\n")
  end
end
