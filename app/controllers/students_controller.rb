class StudentsController < ApplicationController

  load_and_authorize_resource

  before_filter :preload, only: [:new, :edit]

  def index

    respond_to do |f|
      f.html do
        @students = Student
        .include_courses
        .includes(:user => [:role => :translations])
        .order("surname ASC")
        .paginate(:page => params[:page].to_i < 1 ? 1 : params[:page], :per_page => params[:per_page].to_i < 1 ? 15 : params[:per_page])
      end
      f.js do
        @students = Student.search(params[:search_by])
        .include_courses
        .includes(:user => [:role => :translations])
        .paginate(:page => 1, :per_page => 10, :order => 'surname ASC')
        render layout: false
      end
      f.json do
        students = Student.not_enrolled.search_by_full_name(params[:q]).paginate(:page => 1, :per_page => 10, :order => 'surname ASC').collect do |student|
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

  def new
    @student.build_user
    @student.student_studies.build
  end

  def create
    if @student.save
      @student.user.silent_activate!
      redirect_to student_path(@student)
    else
      preload
      flash.now[:error] = @student.errors.full_messages
      render action: :new
    end
  end

  def edit

  end

  def update
    if @student.update(student_params)
      redirect_to student_path(@student)
    else
      render 'edit'
    end
  end

  def show
  end

  def destroy
    if @student.user.destroy && @student.destroy
      redirect_to students_path
    end
  end

  private
  def student_params
    permit_params = [:name, :surname, :index_number,
      :user_attributes => [:id, :email, :notifications_confirmation,
        :role_id, :password, :password_confirmation],
      :student_studies_attributes => [:id, :student_id, :semester_number,
        :studies_id]
    ]
    params.require(:student).permit(permit_params)
  end

  def preload
    @studies = Studies.for_annual(current_annual).includes(course: :translations,
      study_type: :translations, study_degree: :translations)
    .load.sort {|s1, s2| s1.course.name <=> s2.course.name}
    @student_role = Role.where(const_name: :student).first
  end
end
