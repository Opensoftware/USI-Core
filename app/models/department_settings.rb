class DepartmentSettings < ActiveRecord::Base

  belongs_to :annual
  belongs_to :department

  scope :for_annual, ->(annual) { where(annual_id: annual) }
  scope :for_department, ->(department) { where(department_id: department) }
  scope :pick_newest, -> { order("id DESC").first }

end
