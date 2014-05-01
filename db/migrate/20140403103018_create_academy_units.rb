class CreateAcademyUnits < ActiveRecord::Migration
  def change
    create_table :academy_units do |t|
      t.string :short_name
      t.string :code
      t.string :name
      t.string :type
      t.integer :overriding_id
      t.boolean :visible, :default => true

      t.references :annual
      t.timestamps
    end
  end
end
