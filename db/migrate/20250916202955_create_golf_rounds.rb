class CreateGolfRounds < ActiveRecord::Migration[8.0]
  def change
    create_table :golf_rounds do |t|
      t.references :trip, null: false, foreign_key: true
      t.string :course_name
      t.date :date
      t.time :tee_time
      t.decimal :cost_per_person

      t.timestamps
    end
  end
end
