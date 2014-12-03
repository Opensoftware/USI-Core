class UpdateStudentsList

  include Interactor

  def call
    result = ::Student::Persistence
    .const_get("update_from_#{context.file_ext}".camelize)
    .call(:file_absolute_path => context.file_absolute_path)
    if result.failure?
      context.fail!(:message => result.message)
    end

  end

end
