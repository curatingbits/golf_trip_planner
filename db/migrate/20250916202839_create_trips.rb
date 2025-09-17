class CreateTrips < ActiveRecord::Migration[8.0]
  def change
    create_table :trips do |t|
      t.string :name, null: false
      t.string :location, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.decimal :total_cost, precision: 10, scale: 2, null: false
      t.text :description
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :trips, :start_date
    add_index :trips, :active
  end
end
