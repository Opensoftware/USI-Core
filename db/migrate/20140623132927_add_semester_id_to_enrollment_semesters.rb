class AddSemesterIdToEnrollmentSemesters < ActiveRecord::Migration
  def change
    add_column :enrollment_semesters, :semester_id, :integer
  end
end
