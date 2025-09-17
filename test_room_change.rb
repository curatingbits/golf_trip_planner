# Test room change functionality
user = User.find(1)
trip = Trip.find(1)

# Ensure user is registered for the trip
if !user.registered_for_trip?(trip)
  TripRegistration.create!(user: user, trip: trip, registration_date: Time.current)
  puts "User registered for trip"
end

# Check current room
current_room = user.room_for_trip(trip)
if current_room
  puts "User currently in: #{current_room.name}"
  puts "  Capacity: #{current_room.capacity}"
  puts "  Occupants: #{current_room.current_occupants.map(&:full_name).join(', ')}"
else
  puts "User has not selected a room yet"
  # Select first available room
  room = trip.accommodations.first.rooms.find(&:available?)
  if room
    RoomReservation.create!(
      user: user,
      room: room,
      reservation_date: Time.current
    )
    puts "\nSelected room: #{room.name}"
    current_room = room
  end
end

# Try to change rooms
if current_room
  puts "\nLooking for another available room..."
  new_room = trip.accommodations.flat_map(&:rooms).find do |room|
    room != current_room && room.available?
  end

  if new_room
    puts "Found available room: #{new_room.name}"

    # Delete old reservation
    old_reservation = user.room_reservations.joins(room: { accommodation: :trip })
                          .where(trips: { id: trip.id }).first
    old_reservation&.destroy

    # Create new reservation
    RoomReservation.create!(
      user: user,
      room: new_room,
      reservation_date: Time.current
    )

    puts "\nSuccessfully changed rooms:"
    puts "  From: #{current_room.name}"
    puts "  To: #{new_room.name}"
    puts "  New room occupants: #{new_room.reload.current_occupants.map(&:full_name).join(', ')}"
  else
    puts "No other available rooms found"
  end
end