namespace :db do
  desc "Update existing data with new fields"
  task fix_data: :environment do
    # Update accommodations with missing fields
    Accommodation.all.each do |acc|
      if acc.total_cost.nil?
        acc.update!(
          total_cost: 5000.00,
          check_in_date: acc.trip.start_date,
          check_out_date: acc.trip.end_date,
          description: "Luxury accommodation for #{acc.trip.name}"
        )
      end
    end
    puts "Updated #{Accommodation.count} accommodations"

    # Update rooms with missing fields
    Room.all.each_with_index do |room, index|
      if room.room_number.nil?
        room.update!(
          room_number: (index + 1).to_s,
          description: "Comfortable room with all amenities"
        )
      end
    end
    puts "Updated #{Room.count} rooms"

    # Update betting pools with missing fields
    BettingPool.all.each do |pool|
      if pool.entry_fee.nil?
        pool.update!(
          entry_fee: pool.cost_per_person || 100.00,
          pool_type: case pool.name
                     when /team/i then 'team_bet'
                     when /skin/i then 'skins'
                     when /2/i, /two/i then 'twos'
                     else 'custom'
                     end,
          active: true
        )
      end
    end
    puts "Updated #{BettingPool.count} betting pools"

    # Create courses for existing golf rounds
    GolfRound.all.each do |round|
      if round.course.nil? && round.course_name.present?
        course = Course.find_or_create_by!(name: round.course_name) do |c|
          c.address = "#{round.course_name}, Scottsdale, AZ"
          c.par = 72
          c.yardage = 7200
          c.rating = 73.5
          c.slope = 130
        end
        round.update!(
          course: course,
          description: "Championship course with challenging layout"
        )
      end
    end
    puts "Updated #{GolfRound.count} golf rounds with courses"
  end
end