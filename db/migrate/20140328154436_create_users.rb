class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token
      t.integer :login_count
      t.integer :status
      t.string :verifable_type
      t.datetime :last_request_at
      t.string :perishable_token, :default => "", :null => false
      t.integer :failed_login_count
      t.text :preferences

      t.references :role, :verifable, :language
      t.timestamps
    end

    add_index(:users, [:verifable_id], name: 'by_verifable')
  end
end
