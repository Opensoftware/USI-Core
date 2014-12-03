require 'digest/sha1'
require 'tmpdir'

class Student::PersistStudentList

  include Interactor

  def call
    uploaded_io = context.student_list
    file_name = Digest::SHA1.hexdigest("#{uploaded_io.original_filename}#{Time.now.to_s}")
    absolute_path = File.join(Dir.tmpdir, file_name)
    File.open(absolute_path, 'wb') do |file|
      file.write(uploaded_io.read)
    end
    context.file_absolute_path = absolute_path
  end

end
