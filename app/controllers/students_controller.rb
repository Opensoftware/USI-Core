class StudentsController < ApplicationController


  def index

    respond_to do |f|
      f.json do
        students = Student.paginate(:page => 1, :per_page => 10, :conditions => ['surname like ?', "%#{params[:q]}%"], :order => 'surname ASC').collect do |student|
          {:value => student.surname}
        end
        render :json => students.to_json
      end
    end
  end
end
