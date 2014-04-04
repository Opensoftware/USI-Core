class CreateAcademyUnitTranslations < ActiveRecord::Migration

  def up
    AcademyUnit.create_translation_table! :name => :string
  end

  def down
    AcademyUnit.drop_translation_table!
  end
end
