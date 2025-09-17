class AddDepositFieldsToTripRegistrations < ActiveRecord::Migration[8.0]
  def change
    add_column :trip_registrations, :deposit_paid, :boolean, default: false, null: false
    add_column :trip_registrations, :deposit_paid_date, :datetime
    add_column :trip_registrations, :deposit_confirmed_by_id, :integer

    add_index :trip_registrations, :deposit_confirmed_by_id
    add_foreign_key :trip_registrations, :users, column: :deposit_confirmed_by_id
  end
end
