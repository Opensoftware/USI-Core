class AddVisibleToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :visible, :boolean, :default => true
  end
end
