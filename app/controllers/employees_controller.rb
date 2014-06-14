class EmployeesController < ApplicationController

  authorize_resource

  before_filter :preload, only: [:new, :edit]

  def index
    respond_to do |f|
      f.html do
        @employees = Employee.includes(:employee_title,
          :department => :translations, :user => [:role => :translations])
        .order("surname ASC")
        .paginate(:page => params[:page].to_i < 1 ? 1 : params[:page], :per_page => params[:per_page].to_i < 1 ? 15 : params[:per_page])
      end
      f.js do
        @employees = Employee.search(params[:search_by])
        .includes(:employee_title,
          :department => :translations, :user => [:role => :translations])
        .paginate(:page => 1, :per_page => 10, :order => 'surname ASC')
        render layout: false
      end
      f.json do
        employees = Employee.where("department_id IS NOT NULL")
        .paginate(:page => 1, :per_page => 10, :conditions => ['surname ilike ?', "%#{params[:q]}%"], :order => 'surname ASC').collect do |employee|
          {
            value: "#{employee.surname} #{employee.name}",
            academy_unit: "#{t(employee.academy_unit.kind_of_faculty? ? :label_faculty_singular : :label_department_singular)} #{employee.academy_unit.try(:name)}",
            id: employee.id
          }
        end
        render :json => employees.to_json
      end
    end
  end

  def new
    @employee = Employee.new
    @employee.build_user
  end

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      @employee.user.silent_activate!
      redirect_to employee_path(@employee)
    else
      preload
      flash.now[:error] = @employee.errors.full_messages
      render action: :new
    end
  end

  def edit
    @employee = Employee.find(params[:id])

  end

  def update
    @employee = Employee.find(params[:id])
    if @employee.update(employee_params)
      redirect_to employee_path(@employee)
    else
      render 'edit'
    end
  end

  def show
    @employee = Employee.find(params[:id])
  end

  def destroy
    @employee = Employee.find(params[:id])
    if @employee.user.destroy && @employee.destroy
      redirect_to employees_path
    end
  end

  private
  def employee_params
    permit_params = [:name, :surname, :building_id, :department_id, :academy_unit_id,
      :employee_title_id, :user_attributes => [:id, :email, :notifications_confirmation,
        :role_id, :password, :password_confirmation]]
    params.require(:employee).permit(permit_params)
  end

  def preload
    @departments = Department.includes(:translations).all.collect do |dep|
      ["#{dep.faculty.short_name} - #{t(:label_filter_department)} #{dep.name}", dep.id]
    end.to_a
    @academy_units = Faculty.where(type: "Faculty").load.collect do |f|
      ["#{t(:label_faculty_singular)} #{f.name}", f.id]
    end.to_a
    @academy_units |= @departments
    @academy_units.sort!
    @buildings = [[t(:label_choose), '']] | Building.all.load.collect do |b|
      [b.name, b.id]
    end.to_a
    @employee_titles = EmployeeTitle.all
    @roles = Role.all.visible.except_role(:student).sort
  end

end
