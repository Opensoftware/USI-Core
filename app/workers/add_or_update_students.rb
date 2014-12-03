class AddOrUpdateStudents

  @queue = :upload

  def self.perform(file_absolute_path, file_ext, current_user_id)

    result = UpdateStudentsList.call(file_absolute_path: file_absolute_path,
                                     file_ext: file_ext)
    if result.success?
      UserMailer.students_list_upgrade_succeseed(current_user_id).deliver
    else
      UserMailer.students_list_upgrade_failed(current_user_id, result.message).deliver
    end
  end


end
