class Student < ActiveRecord::Base

  include PgSearch
  pg_search_scope :search_by_full_name, :against => [:surname, :name],
    :using => {
    :tsearch => {:prefix => true}
  }

  has_one :user, :as => :verifable, :dependent => :destroy, :class_name => "User"
  accepts_nested_attributes_for :user, :allow_destroy => true
  has_many :student_studies, :class_name => "StudentStudies", :dependent => :destroy
  accepts_nested_attributes_for :student_studies, :allow_destroy => true
  has_many :studies, :class_name => "Studies", :through => :student_studies
  has_many :courses, :through => :studies

  def ==(other)
    index_number == other.index_number
  end

  def self.include_courses
    includes(:student_studies => [:studies => [:course => :translations,
          :study_type => :translations, :study_degree => :translations]])
  end
  
  def self.search(query)
    if query.present?
      search_by_full_name(query)
    else
      self
    end
  end

  if defined?(Diamond)
    has_many :enrollments, :class_name => "Diamond::ThesisEnrollment", :dependent => :destroy
    has_many :theses, :class_name => "Diamond::Thesis", :dependent => :nullify, :through => :enrollments

    def self.not_enrolled
      student_ids = Student.select("DISTINCT #{Student.table_name}.id")
      .joins("LEFT JOIN #{Diamond::ThesisEnrollment.table_name} ON #{Diamond::ThesisEnrollment.table_name}.student_id = #{Student.table_name}.id ")
      .where("NOT EXISTS(SELECT id from #{Diamond::ThesisEnrollment.table_name}
WHERE #{Diamond::ThesisEnrollment.table_name}.student_id = #{Student.table_name}.id AND #{Diamond::ThesisEnrollment.table_name}.state = 'accepted')")
      student_ids |= Student
      .select("DISTINCT #{Student.table_name}.id")
      .joins("LEFT JOIN #{Diamond::ThesisEnrollment.table_name} ON #{Diamond::ThesisEnrollment.table_name}.student_id = #{Student.table_name}.id")
      .joins("LEFT JOIN #{StudentStudies.table_name} ON #{StudentStudies.table_name}.student_id = #{Student.table_name}.id")
      .where("(#{Diamond::ThesisEnrollment.table_name}.student_id = #{Student.table_name}.id AND #{Diamond::ThesisEnrollment.table_name}.state = 'accepted')
OR #{Diamond::ThesisEnrollment.table_name}.id IS NULL")
      .group("#{Student.table_name}.id")
      .having("count(DISTINCT #{Diamond::ThesisEnrollment.table_name}.id) < count(DISTINCT #{StudentStudies.table_name}.id)")
      Student.where(id: student_ids)
    end

    def enrolled_for_thesis?(thesis)
      thesis.enrollments.any? {|enrollment| enrollment.student_id == id }
    end

    def enrolled?
      enrollments.accepted.count == student_studies.count
    end

    def has_enrollment?(enrollment)
      enrollments.include?(enrollment)
    end
  end


  def surname_name
    "#{surname} #{name}"
  end
end
