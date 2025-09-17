class CreateItineraryItems < ActiveRecord::Migration[8.0]
  def change
    create_table :itinerary_items do |t|
      t.references :trip, null: false, foreign_key: true
      t.date :date
      t.string :activity_type
      t.string :title
      t.text :description
      t.string :location
      t.time :start_time
      t.time :end_time

      t.timestamps
    end
  end
end
