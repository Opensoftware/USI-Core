class CreatePermissionRoles < ActiveRecord::Migration
  def change
    create_table :permission_roles do |t|
      t.references :permission, :role
    end

    add_index :permission_roles, [:permission_id, :role_id], name: 'by_permission_role'
  end
end
