class CreateSpecializationTranslations < ActiveRecord::Migration

  def up
    Specialization.create_translation_table! :name => :string
  end
  def down
    Specialization.drop_translation_table!
  end
end
