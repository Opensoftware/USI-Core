class CreateStudies < ActiveRecord::Migration
  def change
    create_table :studies do |t|
      t.integer :semester_number
      t.references :course, :student, :study_type, :study_degree, :specialty
      t.timestamps
    end

    add_index(:studies, [:course_id, :student_id], name: 'by_course_student')
    add_index(:studies, [:student_id], name: 'studies_by_student')
  end
end
