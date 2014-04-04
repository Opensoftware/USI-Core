class Employee < ActiveRecord::Base

  belongs_to :academy_unit, :class_name => "AcademyUnit",
             :foreign_key => :academy_unit_id
  belongs_to :department, :class_name => "Department",
             :foreign_key => :department_id
  belongs_to :employee_title

end
