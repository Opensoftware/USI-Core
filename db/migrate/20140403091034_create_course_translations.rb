class CreateCourseTranslations < ActiveRecord::Migration
  def up
    Course.create_translation_table! :name => :string
  end
  def down
    Course.drop_translation_table!
  end
end
