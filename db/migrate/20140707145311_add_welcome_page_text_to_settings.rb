class AddWelcomePageTextToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :welcome_text, :text
  end
end
