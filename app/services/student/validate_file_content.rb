class Student::ValidateFileContent

  include Interactor

  def call
    result = ::Student::Validator
    .const_get("#{context.file_ext}_validator".classify)
    .call(:file_absolute_path => context.file_absolute_path)
    if result.failure?
      context.fail!(:message => result.message, :row_data => result.row_data,
                    :row_number => result.row_number)
    end
  end
end
