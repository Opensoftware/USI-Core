class EnrollmentSemester < ActiveRecord::Base

  belongs_to :annual
  belongs_to :semester

end
