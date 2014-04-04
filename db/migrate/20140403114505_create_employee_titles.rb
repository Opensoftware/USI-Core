class CreateEmployeeTitles < ActiveRecord::Migration
  def change
    create_table :employee_titles do |t|
      t.string :name

      t.timestamps
    end
  end
end
