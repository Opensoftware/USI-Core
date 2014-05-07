class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name, :limit => 40
      t.string :const_name
      t.string :description
      t.timestamps
    end
  end
end
