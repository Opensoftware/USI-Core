class Studies < ActiveRecord::Base

  belongs_to :course
  belongs_to :student
  belongs_to :study_degree
  belongs_to :study_type
  belongs_to :branch_office
  belongs_to :specialization, foreign_key: "specialty_id"
  has_many :student_studies, :class_name => "StudentStudies", :dependent => :destroy
  has_many :students, :through => :student_studies

  validates :course_id, uniqueness: { scope: [:study_type_id, :study_degree_id,
      :specialty_id, :branch_office_id, :annual_id] }
  validates :course_id, :study_type_id, :study_degree_id, :annual_id, presence: true

  scope :for_annual, ->(annual) { where(annual_id: annual) }

  def self.include_peripherals
    includes(:course => :translations, :study_degree => :translations,
      :study_type => :translations)
  end

  def <=>(other)
    course.name <=> other.course.name
  end
end
