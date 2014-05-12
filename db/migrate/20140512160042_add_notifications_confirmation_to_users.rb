class AddNotificationsConfirmationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notifications_confirmation, :boolean, :default => :true
  end
end
