class AddCourseIdAndDescriptionToGolfRounds < ActiveRecord::Migration[8.0]
  def change
    add_column :golf_rounds, :course_id, :bigint
    add_column :golf_rounds, :description, :text
    add_index :golf_rounds, :course_id
    add_foreign_key :golf_rounds, :courses
  end
end
