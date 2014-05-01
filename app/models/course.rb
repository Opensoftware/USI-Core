class Course < ActiveRecord::Base

  translates :name

  belongs_to :faculty, :class_name => 'Faculty', :foreign_key => :academy_unit_id
  has_one :university, :through => :faculty
  has_one :annual, :through => :faculty

  if defined? Diamond
    has_many :course_theses, :class_name => "Diamond::CourseThesis"
    has_many :theses, :dependent => :nullify, :class_name => "Diamond::Thesis"
  end

  scope :for_annual, ->(annual) { joins(:faculty => :annual).where("#{Annual.table_name}.id" => annual) }

  def to_s
    name
  end

end
