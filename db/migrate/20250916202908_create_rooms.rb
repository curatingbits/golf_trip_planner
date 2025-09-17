class CreateRooms < ActiveRecord::Migration[8.0]
  def change
    create_table :rooms do |t|
      t.references :accommodation, null: false, foreign_key: true
      t.string :name
      t.string :room_type
      t.integer :capacity
      t.decimal :cost_per_person
      t.text :beds_description

      t.timestamps
    end
  end
end
