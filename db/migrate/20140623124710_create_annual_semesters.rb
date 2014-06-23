class CreateAnnualSemesters < ActiveRecord::Migration
  def change
    create_table :annual_semesters do |t|
      t.references :annual, :semester
      t.timestamps
    end

    add_index :annual_semesters, [:annual_id, :semester_id], name: 'annual_semesters_by_annual_semester'
  end
end
