class EmployeesController < ApplicationController

  def index

    respond_to do |f|
      f.json do
        students = Employee.paginate(:page => 1, :per_page => 10, :conditions => ['surname ilike ?', "%#{params[:q]}%"], :order => 'surname ASC').collect do |employee|
          {
            value: "#{employee.surname} #{employee.name}",
            id: employee.id
          }
        end
        render :json => students.to_json
      end
    end
  end
end
