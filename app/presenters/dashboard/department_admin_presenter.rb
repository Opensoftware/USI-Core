class Dashboard::DepartmentAdminPresenter < Dashboard::EmployeePresenter

  def initialize(kontroler)
    super(kontroler, :department,
          kontroler.current_user.verifable.academy_unit_id)
  end

  def view_name
    "department_admin"
  end

  def enrollment_messages
    @enrollment_messages ||= Diamond::ThesisMessage
    .for_enrollment.for_employee(kontroler.current_user)
    .paginate(page: page, per_page: per_page)
  end

  def thesis_state_messages
    []
  end


end
