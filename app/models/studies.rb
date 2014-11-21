class Studies < ActiveRecord::Base

  belongs_to :course
  belongs_to :student
  belongs_to :study_degree
  belongs_to :study_type
  belongs_to :branch_office
  belongs_to :specialization, foreign_key: "specialty_id"
  has_many :student_studies, :class_name => "StudentStudies", :dependent => :destroy
  has_many :students, :through => :student_studies
  has_many :elective_block_studies, class_name: "Graphite::ElectiveBlockStudies"
  has_many :annual_studies, dependent: :destroy
  has_many :annuals, through: :annual_studies

  validates :course_id, uniqueness: { scope: [:study_type_id, :study_degree_id,
                                              :specialty_id, :branch_office_id, :annual_id] }
  validates :course_id, :study_type_id, :study_degree_id, :annual_id, presence: true

  scope :for_annual, ->(annual) { joins(:annual_studies)
                                  .where(annual_studies: {annual_id: annual}) }

  def self.include_peripherals
    includes(:course => :translations, :study_degree => :translations,
             :study_type => :translations)
  end

  def <=>(other)
    course.name <=> other.course.name
  end

  def full_name
    [course.name, *("(#{specialization.name})" if specialty_id.present?),
     " - #{study_type.name.downcase} #{study_degree.name.camelize(:lower)}"].join(" ")
  end

  %w(first second).each do |prefix|
    define_method "#{prefix}_degree?" do
      study_degree.send("#{prefix}_degree?")
    end
  end

end
