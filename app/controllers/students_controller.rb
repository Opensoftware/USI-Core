class StudentsController < ApplicationController

  authorize_resource

  def index

    respond_to do |f|
      f.json do
        students = Student.not_enrolled.paginate(:page => 1, :per_page => 10, :conditions => ['surname ilike ?', "%#{params[:q]}%"], :order => 'surname ASC').collect do |student|
          {
            value: "#{student.surname} #{student.name}",
            index_number: student.index_number,
            studies: student.student_studies.collect{|s| "#{s.studies.course.name} (#{s.studies.study_degree.name.camelize(:lower)}), #{t(:label_semester).downcase} #{s.semester_number}" },
            id: student.id
          }
        end
        render :json => students.to_json
      end
    end
  end
end
