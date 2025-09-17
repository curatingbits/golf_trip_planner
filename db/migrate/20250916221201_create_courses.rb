class CreateCourses < ActiveRecord::Migration[8.0]
  def change
    create_table :courses do |t|
      t.string :name
      t.text :address
      t.integer :par
      t.integer :yardage
      t.decimal :rating
      t.integer :slope

      t.timestamps
    end
  end
end
