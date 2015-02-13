class Dashboard::StudentPresenter < Dashboard::DashboardPresenter

  def view_name
    "student"
  end

  def enrollments
    @enrollments ||= promise { kontroler.current_user.student
                               .thesis_enrollments.includes(:thesis) }
  end

  def elective_modules
    if @elective_modules.blank?
      elective_module_ids = Graphite::ElectiveBlock
      .select("DISTINCT #{Graphite::ElectiveBlock.table_name}.*")
      .for_student_semester(kontroler.current_user.student.student_studies
                            .collect{ |ss| ss.semester_number+1})
      .for_student(kontroler.current_user.student)
      .pluck("#{Graphite::ElectiveBlock.table_name}.id")
    end
    @elective_modules ||= Graphite::ElectiveBlock.where(id: elective_module_ids)
    .include_peripherals
    .includes(:enrollments, :elective_blocks => [:translations,
                                                 :modules => [:translations]])
  end

  def elective_module_enrollments
    @elective_module_enrollments ||= Graphite::ElectiveBlock::Enrollment
      .for_student(kontroler.current_user.student)
      .for_elective_block(elective_modules.collect(&:id))
      .not_versioned
  end

end
