class Department < AcademyUnit

  belongs_to :faculty, :class_name => "Faculty", :foreign_key => :overriding_id, :touch => true
  has_many :department_settings, :dependent => :destroy, :class_name => "DepartmentSettings"

  after_create :create_department_settings


  private
  def create_department_settings
    if DepartmentSettings.for_department(self).for_annual(Settings.pick_newest.annual).blank?
      DepartmentSettings.create(department_id: id, annual_id: Settings.pick_newest.current_annual_id)
    end
  end
end
