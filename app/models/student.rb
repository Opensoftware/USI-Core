class Student < ActiveRecord::Base

  has_one :user, :as => :verifable, :dependent => :destroy, :class_name => "User"
  accepts_nested_attributes_for :user, :allow_destroy => true
  has_many :studies, :class_name => "Studies"
  has_many :courses, :through => :studies

  if defined?(Diamond)
    has_many :enrollments, :class_name => "Diamond::ThesisEnrollment", :dependent => :destroy
  end


  def surname_name
    "#{surname} #{name}"
  end
end
