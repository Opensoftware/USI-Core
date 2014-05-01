class CreateStudyDegrees < ActiveRecord::Migration
  def up
    create_table :study_degrees do |t|
      t.string :name
      t.string :short_name
      t.string :code
      t.timestamps
    end
    StudyDegree.create_translation_table! :name => :string, :short_name => :string
  end
  def down
    StudyDegree.drop_translation_table!
    drop_table :study_degrees
  end
end
