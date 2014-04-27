class CreateStudentStudies < ActiveRecord::Migration
  def change
    create_table :student_studies do |t|
      t.references :student, :studies
      t.timestamps
    end

    add_index(:student_studies, [:student_id, :studies_id], :name => 'by_student_studies')
    add_index(:student_studies, [:studies_id, :student_id], :name => 'by_studies_student')

  end
end
