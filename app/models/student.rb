class Student < ActiveRecord::Base

  include PgSearch
  pg_search_scope :search_by_full_name, :against => [:surname, :name],
    :using => {
    :tsearch => {:prefix => true}
  }

  has_one :user, :as => :verifable, :dependent => :destroy, :class_name => "User"
  accepts_nested_attributes_for :user, :allow_destroy => true
  has_many :student_studies, :class_name => "StudentStudies", :dependent => :destroy
  accepts_nested_attributes_for :student_studies, :allow_destroy => true,
    :reject_if => lambda { |student_studies| student_studies[:studies_id].blank? }
  has_many :studies, :class_name => "Studies", :through => :student_studies
  has_many :courses, :through => :studies

  validates :index_number, uniqueness: true

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
    has_many :thesis_enrollments, :class_name => "Diamond::ThesisEnrollment", :dependent => :destroy
    has_many :theses, :class_name => "Diamond::Thesis", :dependent => :nullify, :through => :thesis_enrollments

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

    def is_authorized_for_thesis_enrollments?
      student_studies.any? do |student_studies|
        (student_studies.studies.second_degree? && student_studies.semester_number >= 1) ||
          (student_studies.studies.first_degree? && student_studies.semester_number >= 6)
      end
    end

    def enrolled_for_thesis?(thesis)
      thesis.enrollments.any? {|enrollment| enrollment.student_id == id }
    end

    def enrolled?
      thesis_enrollments.accepted.count == student_studies.count
    end

    def has_thesis_enrollment?(enrollment)
      thesis_enrollments.include?(enrollment)
    end
  end

  if defined?(Graphite)
    has_many :elective_enrollments, :class_name => "Graphite::ElectiveBlock::Enrollment",
      dependent: :destroy

    scope :elective_blocks, ->(blocks) do
      joins(:elective_enrollments)
      .where("#{Graphite::ElectiveBlock::Enrollment.table_name}.block_id" => blocks)
    end
    scope :queued_blocks, -> do
      where("#{Graphite::ElectiveBlock::Enrollment.table_name}.state" => 'queued')
    end

    def elective_modules
      Graphite::ElectiveBlock.joins(:studies, :modules)
      .select("DISTINCT #{Graphite::ElectiveBlock.table_name}.*")
      .where("#{Studies.table_name}.id" => student_studies.pluck(:studies_id))
    end

    def any_pending_module_enrollments?
      elective_enrollments
      .select("1 AS ONE")
      .pending
      .not_versioned
      .present?
    end

    def has_pending_enrollments_for_module?(mod)
      elective_enrollments
      .select("1 AS ONE")
      .where("#{Graphite::ElectiveBlock::Enrollment.table_name}.elective_block_id" => mod)
      .pending
      .not_versioned
      .present?
    end

    def has_queued_enrollments_for_module?(mod)
      elective_enrollments
      .select("1 AS ONE")
      .where("#{Graphite::ElectiveBlock::Enrollment.table_name}.elective_block_id" => mod)
      .queued
      .not_versioned
      .present?
    end
  end



  def surname_name
    "#{surname} #{name}"
  end
end
