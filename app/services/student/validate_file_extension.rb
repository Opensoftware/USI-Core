require 'rack/mime'

class Student::ValidateFileExtension

  include Interactor

  VALID_MIMES = %w(application/vnd.ms-excel
                   application/vnd.openxmlformats-officedocument.spreadsheetml.sheet)


  def call
    uploaded_io = context.student_list
    file_ext = Rack::Mime::MIME_TYPES.invert[uploaded_io.content_type.chomp]

    unless VALID_MIMES.include?(uploaded_io.content_type.chomp) || file_ext
      context.fail!(:message => "error.xls_file_type_incorrect")
    else
      context.file_ext = file_ext.gsub(/\./, '')
      context.message = "notice_student_list_upgrade_pending"
    end
  end
end
