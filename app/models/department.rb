class Department < AcademyUnit

  belongs_to :faculty, :class_name => "Faculty", :foreign_key => :overriding_id, :touch => true
end
