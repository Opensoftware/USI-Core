class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :short_name
      t.string :code
      t.string :name
      t.integer :academy_unit_id

      t.timestamps
    end
  end
end
