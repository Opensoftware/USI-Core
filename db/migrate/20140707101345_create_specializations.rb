class CreateSpecializations < ActiveRecord::Migration
  def change
    create_table :specializations do |t|
      t.string :short_name
      t.string :code
      t.string :name

      t.references :course
      t.timestamps
    end
  end
end
