class Dashboard::SupervisorPresenter < Dashboard::EmployeePresenter

  def initialize(kontroler)
    super(kontroler, :supervisor, kontroler.current_user.verifable_id)
  end

  def view_name
    "supervisor"
  end

  def enrollment_messages
    @enrollment_messages ||= Diamond::ThesisMessage.for_enrollment
    .for_employee(kontroler.current_user)
    .paginate(page: page, per_page: per_page)
  end

  def thesis_state_messages
    @thesis_state_messages ||= Diamond::ThesisMessage.for_thesis_state
    .for_employee(kontroler.current_user)
    .paginate(page: page, per_page: per_page)
  end


end
