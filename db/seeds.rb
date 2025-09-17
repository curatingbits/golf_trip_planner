# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Creating admin user..."
admin = User.find_or_create_by!(email: "admin@golftrip.com") do |user|
  user.first_name = "Golf"
  user.last_name = "Admin"
  user.handicap = 10.0
  user.password = "password123"
  user.admin = true
end

puts "Creating Scottsdale 2026 Golf Trip..."
scottsdale_trip = Trip.find_or_create_by!(name: "Scottsdale Golf Trip 2026") do |trip|
  trip.location = "Scottsdale, Arizona"
  trip.start_date = Date.new(2026, 3, 25)
  trip.end_date = Date.new(2026, 3, 29)
  trip.total_cost = 13367.79
  trip.description = <<~MARKDOWN
# March Golf Trip to HÓZHÓ Residence, Scottsdale

Welcome to an unforgettable golf getaway at the luxurious **HÓZHÓ Residence on Sweetwater** in Scottsdale! This 8-bed, 6.5-bath designer mansion is our home base, offering a resort-style backyard with a saltwater pool, outdoor TVs, a putting green, ping pong, and a relaxing cabana. The gourmet kitchen is fully stocked for home-cooked meals, perfect for our group of 20 to unwind and bond.

## Golfing Adventure

We'll conquer three stunning courses:
- **Quintero**: A desert masterpiece with breathtaking views.
- **We-Ko-Pa**: A golfer's paradise with challenging fairways.
- **Phoenician**: Iconic and scenic, perfect for our epic showdown.

The highlight is our **Ryder Cup match**, led by captains **LT** and **Rusty**—two relentless competitors who'll stop at nothing to win. Expect fierce battles and endless trash talk!

## Beyond the Fairways

We'll indulge in Scottsdale's best:
- **Dining**: Savor world-class cuisine at top restaurants.
- **Nightlife**: Dive into the vibrant Scottsdale scene.
- **Shopping**: Explore high-end spots like Scottsdale Quarter and Kierland Commons.

From golf to good times, this trip will be a hole-in-one, filled with laughter, competition, and memories to cherish!
MARKDOWN
  trip.active = true
end

puts "Creating HÓZHÓ Residence accommodation..."
hozo_residence = Accommodation.find_or_create_by!(
  trip: scottsdale_trip,
  name: "HÓZHÓ Residence on Sweetwater"
) do |accommodation|
  accommodation.accommodation_type = "house"
  accommodation.address = "Sweetwater, Scottsdale, AZ"
  accommodation.contact_info = "H & H Vacations, tony@houseandhomevacations.com, 480-772-8284"
end

puts "Creating rooms for HÓZHÓ Residence..."

# Room pricing calculations based on the provided cost breakdown
base_cost = 835.49
private_surcharge = base_cost * 0.4
bunk_discount = base_cost * 0.2

private_cost = base_cost + private_surcharge  # ~$1169.69
bunk_cost = base_cost - bunk_discount         # ~$668.39
shared_cost = base_cost                       # ~$835.49

rooms_data = [
  {
    name: "Master Bedroom",
    room_type: "private",
    capacity: 2,
    cost_per_person: private_cost,
    beds_description: "1 King bed"
  },
  {
    name: "Bunk Room",
    room_type: "shared",
    capacity: 4,
    cost_per_person: bunk_cost,
    beds_description: "4 Full beds (2 Full-over-Full bunks)"
  },
  {
    name: "3rd Bedroom",
    room_type: "private",
    capacity: 2,
    cost_per_person: private_cost,
    beds_description: "1 King bed"
  },
  {
    name: "4th Bedroom",
    room_type: "shared",
    capacity: 4,
    cost_per_person: shared_cost,
    beds_description: "1 King + 2 Twins (Trundle)"
  },
  {
    name: "5th Bedroom",
    room_type: "shared",
    capacity: 2,
    cost_per_person: shared_cost,
    beds_description: "1 King bed"
  },
  {
    name: "6th Bedroom",
    room_type: "shared",
    capacity: 2,
    cost_per_person: shared_cost,
    beds_description: "1 King bed"
  },
  {
    name: "7th Bedroom",
    room_type: "shared",
    capacity: 2,
    cost_per_person: shared_cost,
    beds_description: "1 Queen bed"
  },
  {
    name: "8th Bedroom",
    room_type: "shared",
    capacity: 2,
    cost_per_person: shared_cost,
    beds_description: "1 Queen bed"
  }
]

rooms_data.each do |room_data|
  Room.find_or_create_by!(
    accommodation: hozo_residence,
    name: room_data[:name]
  ) do |room|
    room.room_type = room_data[:room_type]
    room.capacity = room_data[:capacity]
    room.cost_per_person = room_data[:cost_per_person]
    room.beds_description = room_data[:beds_description]
  end
end

puts "Creating golf rounds..."

golf_rounds_data = [
  {
    course_name: "We-Ko-Pa",
    date: Date.new(2026, 3, 26),
    tee_time: Time.parse("11:00 AM"),
    cost_per_person: 250.00
  },
  {
    course_name: "Quintero",
    date: Date.new(2026, 3, 27),
    tee_time: Time.parse("11:00 AM"),
    cost_per_person: 325.00
  },
  {
    course_name: "Troon Monument",
    date: Date.new(2026, 3, 28),
    tee_time: Time.parse("11:00 AM"),
    cost_per_person: 300.00
  }
]

golf_rounds_data.each do |round_data|
  GolfRound.find_or_create_by!(
    trip: scottsdale_trip,
    course_name: round_data[:course_name],
    date: round_data[:date]
  ) do |round|
    round.tee_time = round_data[:tee_time]
    round.cost_per_person = round_data[:cost_per_person]
  end
end

puts "Creating betting pools..."

betting_pools_data = [
  {
    name: "Team Bet",
    cost_per_person: 300.00,
    description: "Team-based betting for the entire trip"
  },
  {
    name: "Skins",
    cost_per_person: 150.00,
    description: "Individual hole skins game"
  },
  {
    name: "2's",
    cost_per_person: 50.00,
    description: "Closest to the pin on par 2s"
  }
]

betting_pools_data.each do |pool_data|
  BettingPool.find_or_create_by!(
    trip: scottsdale_trip,
    name: pool_data[:name]
  ) do |pool|
    pool.cost_per_person = pool_data[:cost_per_person]
    pool.description = pool_data[:description]
  end
end

puts "Creating confirmed players..."

confirmed_players = [
  "Duggan Roberts", "Preston Capron", "Nathan Sandmann", "Tyler Delval",
  "Ben Erhardt", "Brett Cudd", "Eric Baxter", "Bill Taylor", "Chad Patzke",
  "Clint Gagnon", "Londell Taylor", "Mark Litton", "Rich Hull", "Rusty Wells",
  "Aaron Wick", "Chris Woodall"
]

confirmed_players.each_with_index do |full_name, index|
  first_name, last_name = full_name.split(" ", 2)
  email = "#{first_name.downcase}.#{last_name.downcase}@golftrip.com"

  user = User.find_or_create_by!(email: email) do |u|
    u.first_name = first_name
    u.last_name = last_name
    u.handicap = rand(5.0..25.0).round(1)
    u.password = "password123"
    u.admin = false
  end

  # Register user for the trip
  TripRegistration.find_or_create_by!(
    user: user,
    trip: scottsdale_trip
  ) do |registration|
    registration.registration_date = Time.current - (15 - index).days
  end
end

puts "Seed data created successfully!"
puts "Admin user: admin@golftrip.com (password: password123)"
puts "Scottsdale 2026 Golf Trip created with:"
puts "  - 8 rooms in HÓZHÓ Residence"
puts "  - 3 golf rounds"
puts "  - 3 betting pools"
puts "  - 16 confirmed players"
