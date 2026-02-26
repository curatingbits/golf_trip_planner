class AddRoomAndBettingPaidToTripRegistrations < ActiveRecord::Migration[8.0]
  def change
    add_column :trip_registrations, :room_paid, :boolean, default: false, null: false
    add_column :trip_registrations, :room_paid_date, :datetime
    add_column :trip_registrations, :room_confirmed_by_id, :integer
    add_column :trip_registrations, :betting_paid, :boolean, default: false, null: false
    add_column :trip_registrations, :betting_paid_date, :datetime
    add_column :trip_registrations, :betting_confirmed_by_id, :integer

    add_index :trip_registrations, :room_confirmed_by_id
    add_index :trip_registrations, :betting_confirmed_by_id
  end
end
