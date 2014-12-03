class Student::AddOrUpdateStudents

  include Interactor

  def call
    ::Resque.enqueue(::AddOrUpdateStudents, context.file_absolute_path,
                     context.file_ext, context.current_user.id)
  end

end
