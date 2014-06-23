class AnnualSemester < ActiveRecord::Base

  belongs_to :annual
  belongs_to :semester

end
