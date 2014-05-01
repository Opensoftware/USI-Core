class EnrollmentSemestersController < ApplicationController

  def edit
    @semester = EnrollmentSemester.find(params[:id])
  end

  def update
    @semester = EnrollmentSemester.find(params[:id])

    if @semester.update(enrollment_semester_params)
      redirect_to dashboard_index_path
    else
      render 'edit'
    end

  end

  private
  def enrollment_semester_params
    params.require(:enrollment_semester).permit(:thesis_enrollments_begin, :thesis_enrollments_end, :elective_enrollments_begin, :elective_enrollments_end)
  end

end
