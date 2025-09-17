class AddMissingFieldsToRooms < ActiveRecord::Migration[8.0]
  def change
    add_column :rooms, :room_number, :string
    add_column :rooms, :description, :text
  end
end
