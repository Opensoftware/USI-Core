class AcademyUnit < ActiveRecord::Base

  serialize :special_conditions, Hash

  translates :name

  has_many :courses, :foreign_key => :academy_unit_id, :dependent => :destroy

  validates :short_name, :code, presence: true
  validates :code, uniqueness: { scope: [:short_name, :type] }

  def kind_of_faculty?
    type == 'Faculty'
  end

end
