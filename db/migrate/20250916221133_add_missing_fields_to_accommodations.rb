class AddMissingFieldsToAccommodations < ActiveRecord::Migration[8.0]
  def change
    add_column :accommodations, :total_cost, :decimal
    add_column :accommodations, :check_in_date, :date
    add_column :accommodations, :check_out_date, :date
    add_column :accommodations, :description, :text
  end
end
