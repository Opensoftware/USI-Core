class CreateTranslationsForRoles < ActiveRecord::Migration
  def up
    Role.create_translation_table! :name => :string
  end

  def down
    Role.drop_translation_table!
  end
end
