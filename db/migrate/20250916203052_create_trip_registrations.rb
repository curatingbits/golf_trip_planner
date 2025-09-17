class CreateTripRegistrations < ActiveRecord::Migration[8.0]
  def change
    create_table :trip_registrations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :trip, null: false, foreign_key: true
      t.datetime :registration_date

      t.timestamps
    end
  end
end
