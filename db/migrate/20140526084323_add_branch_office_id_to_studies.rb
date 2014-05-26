class AddBranchOfficeIdToStudies < ActiveRecord::Migration
  def change
    add_column :studies, :branch_office_id, :integer
  end
end
