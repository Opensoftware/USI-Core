class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :name
      t.string :surname
      t.column :index_number, :bigint
      t.integer :passed_ects
      t.float :average_grade

      t.references :language
      t.timestamps
    end
  end
end
