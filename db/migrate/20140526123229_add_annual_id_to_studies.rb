class AddAnnualIdToStudies < ActiveRecord::Migration
  def change
    add_column :studies, :annual_id, :integer
  end
end
