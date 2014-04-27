class StudentsController < ApplicationController


  def index

    respond_to do |f|
      f.json do
        students = Student.paginate(:page => 1, :per_page => 10, :conditions => ['surname ilike ?', "%#{params[:q]}%"], :order => 'surname ASC').collect do |student|
          {
            value: "#{student.surname} #{student.name}",
            index_number: student.index_number,
            studies: student.studies.collect{|s| "#{s.course.name} (#{s.study_degree.name.camelize(:lower)}), #{t(:label_semester).downcase} #{s.semester_number}" },
            id: student.id
          }
        end
        render :json => students.to_json
      end
    end
  end
end
