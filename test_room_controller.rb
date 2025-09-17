# Test room controller edit action
require 'action_dispatch/testing/integration'

class TestRoomEdit < ActionDispatch::IntegrationTest
  def test_edit_page
    # Login as admin
    admin = User.where(admin: true).first || User.create!(
      email: "test_admin@example.com",
      password: "password123",
      first_name: "Test",
      last_name: "Admin",
      admin: true
    )

    # Get room data
    trip = Trip.first
    accommodation = trip.accommodations.first
    room = accommodation.rooms.first

    if room
      puts "Testing room edit for:"
      puts "  Trip ID: #{trip.id}"
      puts "  Accommodation ID: #{accommodation.id}"
      puts "  Room ID: #{room.id}"

      # Create a mock request
      controller = Admin::RoomsController.new
      controller.params = ActionController::Parameters.new({
        trip_id: trip.id.to_s,
        accommodation_id: accommodation.id.to_s,
        id: room.id.to_s
      })

      # Call private methods to set instance variables
      controller.send(:set_trip_and_accommodation)
      controller.send(:set_room)

      # Try to render the edit view
      controller.edit

      puts "Controller action completed successfully"
    else
      puts "No room found to test"
    end
  end
end

# Run the test
test = TestRoomEdit.new
test.test_edit_page