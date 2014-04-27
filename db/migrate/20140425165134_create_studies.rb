class CreateStudies < ActiveRecord::Migration
  def change
    create_table :studies do |t|
      t.integer :semester_number
      t.references :course, :study_type, :study_degree, :specialty, :faculty
      t.timestamps
    end

    add_index(:studies, [:course_id], name: 'studies_by_course')
    add_index(:studies, [:faculty_id], name: 'studies_by_faculty')
  end
end
