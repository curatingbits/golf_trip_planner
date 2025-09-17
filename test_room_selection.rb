# Test room selection functionality
user = User.find(1)
trip = Trip.find(1)

# Check if user is registered for trip
if !user.registered_for_trip?(trip)
  TripRegistration.create!(user: user, trip: trip, registration_date: Time.current)
  puts "User registered for trip"
end

# Check available rooms
rooms = trip.accommodations.first.rooms
puts "Available rooms for trip #{trip.name}:"
rooms.each do |room|
  puts "  Room #{room.name}: #{room.available_spots}/#{room.capacity} spots available"
  if room.current_occupants.any?
    puts "    Current occupants: #{room.current_occupants.map(&:full_name).join(", ")}"
  end
end

# Check user current room
user_room = user.room_for_trip(trip)
if user_room
  puts "\nUser currently in: #{user_room.name}"
  if user_room.current_occupants.size > 1
    roommates = user_room.current_occupants.reject { |o| o == user }
    puts "  Roommates: #{roommates.map(&:full_name).join(", ")}"
  end
else
  puts "\nUser has not selected a room yet"
end

# Test adding another user to a room
user2 = User.find_or_create_by(email: "jane@example.com") do |u|
  u.password = "password"
  u.first_name = "Jane"
  u.last_name = "Smith"
end

if !user2.registered_for_trip?(trip)
  TripRegistration.create!(user: user2, trip: trip, registration_date: Time.current)
end

# Put user2 in same room as user1
if user_room && user_room.available?
  RoomReservation.create!(
    user: user2,
    room: user_room,
    reservation_date: Time.current
  )
  puts "\nAdded #{user2.full_name} to #{user_room.name}"
  puts "Room now has occupants: #{user_room.current_occupants.map(&:full_name).join(", ")}"
end