# Test room edit functionality
puts "Testing Room Edit Page..."

# Get first room
trip = Trip.first
accommodation = trip.accommodations.first
room = accommodation.rooms.first

if room
  puts "Room found: #{room.room_number}"
  puts "  - ID: #{room.id}"
  puts "  - Accommodation ID: #{accommodation.id}"
  puts "  - Trip ID: #{trip.id}"
  puts "  - Room Type: #{room.room_type}"
  puts "  - Capacity: #{room.capacity}"
  puts "  - Cost Per Person: #{room.cost_per_person}"
  puts "  - Description: #{room.description}"

  # Check for nil values that might cause issues
  if room.room_number.nil?
    puts "WARNING: room_number is nil"
  end

  puts "\nEdit URL would be: /admin/trips/#{trip.id}/accommodations/#{accommodation.id}/rooms/#{room.id}/edit"
else
  puts "No room found!"
end

# Check if any required attributes are missing
puts "\nChecking Room model attributes:"
room_attributes = Room.column_names
puts "Available columns: #{room_attributes.join(', ')}"