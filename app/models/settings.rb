class Settings < ActiveRecord::Base

  belongs_to :annual, :foreign_key => :current_annual_id
  belongs_to :enrollment_semester, :foreign_key => :current_semester_id

end
