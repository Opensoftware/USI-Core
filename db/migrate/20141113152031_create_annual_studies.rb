class CreateAnnualStudies < ActiveRecord::Migration
  def change
    create_table :annual_studies do |t|
      t.timestamps
      t.references :annual, :studies
      t.index [:annual_id, :studies_id]
      t.index [:studies_id, :annual_id]
    end
  end
end
