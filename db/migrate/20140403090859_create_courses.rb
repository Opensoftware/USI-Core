class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :short_name
      t.string :code
      t.string :name

      t.references :academy_unit
      t.timestamps
    end
  end
end
