class CreateSemesterTranslations < ActiveRecord::Migration
  def up
    Semester.create_translation_table! name: :string
  end

  def down
    Semester.drop_translation_table!
  end
end
