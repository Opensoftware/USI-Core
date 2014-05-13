class CreateDepartmentSettings < ActiveRecord::Migration
  def change
    create_table :department_settings do |t|
      t.integer :max_theses_count, :default => 10
      t.references :department, :annual

      t.timestamps
    end
  end
end
