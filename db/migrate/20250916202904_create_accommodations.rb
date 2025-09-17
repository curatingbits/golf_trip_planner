class CreateAccommodations < ActiveRecord::Migration[8.0]
  def change
    create_table :accommodations do |t|
      t.references :trip, null: false, foreign_key: true
      t.string :name
      t.string :accommodation_type
      t.text :address
      t.text :contact_info

      t.timestamps
    end
  end
end
