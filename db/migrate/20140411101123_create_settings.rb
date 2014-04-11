class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.references :current_annual
      t.timestamps
    end
  end
end
