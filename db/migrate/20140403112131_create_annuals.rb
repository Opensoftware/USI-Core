class CreateAnnuals < ActiveRecord::Migration
  def change
    create_table :annuals do |t|
      t.string :name
      t.boolean :locked, :default => 'false'

      t.timestamps
    end
  end
end
