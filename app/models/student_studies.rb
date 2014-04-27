class StudentStudies < ActiveRecord::Base

  belongs_to :studies
  belongs_to :student

end
