class CreateRoomReservations < ActiveRecord::Migration[8.0]
  def change
    create_table :room_reservations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.datetime :reservation_date

      t.timestamps
    end
  end
end
