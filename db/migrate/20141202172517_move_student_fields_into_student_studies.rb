class MoveStudentFieldsIntoStudentStudies < ActiveRecord::Migration
  def change
    add_column :student_studies, :passed_ects, :integer
    add_column :student_studies, :average_grade, :float
  end
end
