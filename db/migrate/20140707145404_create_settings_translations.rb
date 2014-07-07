class CreateSettingsTranslations < ActiveRecord::Migration
  def up
    Settings.create_translation_table! welcome_text: :text
  end

  def down
    Settings.drop_translation_table!
  end
end
