class Student::UploadStudentList

  include Interactor::Organizer

  organize Student::PersistStudentList, ValidateFileExtension,
    ValidateFileContent, Student::AddOrUpdateStudents

end
