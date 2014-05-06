class Student < ActiveRecord::Base

  has_one :user, :as => :verifable, :dependent => :destroy, :class_name => "User"
  accepts_nested_attributes_for :user, :allow_destroy => true
  has_many :student_studies, :class_name => "StudentStudies", :dependent => :destroy
  has_many :studies, :class_name => "Studies", :through => :student_studies
  has_many :courses, :through => :studies

  if defined?(Diamond)
    has_many :enrollments, :class_name => "Diamond::ThesisEnrollment", :dependent => :destroy
    has_many :theses, :class_name => "Diamond::Thesis", :dependent => :nullify, :through => :enrollments

    def self.not_assigned
      Student
      .joins("LEFT JOIN #{Diamond::ThesisEnrollment.table_name} ON #{Diamond::ThesisEnrollment.table_name}.student_id = #{Student.table_name}.id ")
      .where("NOT EXISTS(SELECT id from #{Diamond::ThesisEnrollment.table_name} WHERE #{Diamond::ThesisEnrollment.table_name}.student_id = #{Student.table_name}.id)")
    end

    def enrolled_for_thesis?(thesis)
      thesis.enrollments.any? {|enrollment| enrollment.student_id == id }
    end

    def enrolled?
      enrollments.accepted.any?
    end

    def has_enrollment?(enrollment)
      enrollments.include?(enrollment)
    end
  end


  def surname_name
    "#{surname} #{name}"
  end
end
