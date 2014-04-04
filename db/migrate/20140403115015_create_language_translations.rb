class CreateLanguageTranslations < ActiveRecord::Migration
  def up
    Language.create_translation_table! name: :string
  end

  def down
    Language.drop_translation_table!
  end
end
