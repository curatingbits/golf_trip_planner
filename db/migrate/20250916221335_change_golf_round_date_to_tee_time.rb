class ChangeGolfRoundDateToTeeTime < ActiveRecord::Migration[8.0]
  def change
    # Remove old time column and rename date to tee_time as datetime
    remove_column :golf_rounds, :tee_time, :time if column_exists?(:golf_rounds, :tee_time)
    remove_column :golf_rounds, :date, :date if column_exists?(:golf_rounds, :date)
    add_column :golf_rounds, :tee_time, :datetime unless column_exists?(:golf_rounds, :tee_time)
  end
end
