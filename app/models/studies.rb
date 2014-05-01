class Studies < ActiveRecord::Base

  belongs_to :course
  belongs_to :student
  belongs_to :study_degree

end
