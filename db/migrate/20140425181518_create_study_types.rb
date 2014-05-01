class CreateStudyTypes < ActiveRecord::Migration
  def up
    create_table :study_types do |t|
      t.string :name
      t.string :short_name
      t.string :code
      t.timestamps
    end
    StudyType.create_translation_table! :name => :string, :short_name => :string
  end
  def down
    StudyType.drop_translation_table!
    drop_table :study_types
  end
end
