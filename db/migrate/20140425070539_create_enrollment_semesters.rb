class CreateEnrollmentSemesters < ActiveRecord::Migration
  def change
    create_table :enrollment_semesters do |t|
      t.datetime :thesis_enrollments_begin
      t.datetime :thesis_enrollments_end
      t.datetime :elective_enrollments_begin
      t.datetime :elective_enrollments_end

      t.references :annual
      t.timestamps
    end
  end
end
