# Test if view can render
trip = Trip.first
accommodation = trip.accommodations.first
room = accommodation.rooms.first

if room
  puts "Room data:"
  puts "  room.room_number: #{room.room_number.inspect}"
  puts "  room.room_type: #{room.room_type.inspect}"
  puts "  room.capacity: #{room.capacity.inspect}"
  puts "  room.cost_per_person: #{room.cost_per_person.inspect}"
  puts "  room.description: #{room.description.inspect}"

  # Check if form helpers will work
  puts "\nValidating room for form:"
  if room.valid?
    puts "  ✓ Room is valid"
  else
    puts "  ✗ Room has validation errors:"
    room.errors.full_messages.each do |msg|
      puts "    - #{msg}"
    end
  end

  # Check associations
  puts "\nChecking associations:"
  puts "  accommodation exists: #{room.accommodation.present?}"
  puts "  trip through accommodation: #{room.accommodation.trip.present?}"

  # Try to mimic what the form might be doing
  puts "\nChecking if attributes can be accessed in a form:"
  [:room_number, :room_type, :capacity, :cost_per_person, :description].each do |attr|
    value = room.send(attr)
    puts "  #{attr}: #{value.inspect} (#{value.class})"
  end
else
  puts "No room found!"
end