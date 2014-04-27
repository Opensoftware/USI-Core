class Studies < ActiveRecord::Base

  belongs_to :course
  belongs_to :student
  belongs_to :study_degree
  belongs_to :study_type
  has_many :student_studies, :class_name => "StudentStudies", :dependent => :destroy
  has_many :students, :through => :student_studies

end
