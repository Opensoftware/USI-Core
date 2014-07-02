class AddAvgGradeAndEctsAmountToStudents < ActiveRecord::Migration
  def change
    add_column :students, :avg_grade, :float
    add_column :students, :ects_amount, :integer
  end
end
