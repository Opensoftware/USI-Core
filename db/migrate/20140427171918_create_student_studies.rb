class CreateStudentStudies < ActiveRecord::Migration
  def change
    create_table :student_studies do |t|
      t.integer :semester_number, :default => 1
      t.references :student, :studies
      t.timestamps
    end

    add_index(:student_studies, [:student_id, :studies_id], :name => 'by_student_studies')
    add_index(:student_studies, [:studies_id, :student_id], :name => 'by_studies_student')
    add_index(:student_studies, [:studies_id, :student_id, :semester_number], :name => 'by_studies_student_semester_number')

  end
end
