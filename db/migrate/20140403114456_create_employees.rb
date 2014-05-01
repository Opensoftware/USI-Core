class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :surname
      t.string :name
      t.string :room
      t.string :phone_number
      t.string :www
      t.boolean :delta, :default => true, :null => false

      t.references :academy_unit, :employee_title, :language, :building, :department
      t.timestamps
    end
  end
end
