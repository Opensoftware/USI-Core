class DashboardController < ApplicationController

  def index
    authorize! :read, User

    if current_user.student?
      @enrollments = current_user.student.enrollments.includes(:thesis)
    elsif current_user.employee?

      if can?(:manage, Diamond::Thesis)
      elsif can?(:manage_department, Diamond::Thesis)
        @enrollment_messages = Diamond::ThesisMessage.for_enrollment.for_employee(current_user)
        .paginate(:page => params[:page].to_i < 1 ? 1 : params[:page], :per_page => params[:per_page].to_i < 1 ? 10 : params[:per_page])
      else
        @enrollment_messages = Diamond::ThesisMessage.for_enrollment.for_employee(current_user)
        .paginate(:page => params[:page].to_i < 1 ? 1 : params[:page], :per_page => params[:per_page].to_i < 1 ? 10 : params[:per_page])
        @thesis_state_messages = Diamond::ThesisMessage.for_thesis_state.for_employee(current_user)
        .paginate(:page => params[:page].to_i < 1 ? 1 : params[:page], :per_page => params[:per_page].to_i < 1 ? 10 : params[:per_page])
      end

      @theses = Diamond::Thesis.include_peripherals.newest.pick_five.let do |t|
        t = send("theses_for_#{current_user_permission(Diamond::Thesis)}_permission", t)
      end
    end

    respond_to do |f|
      f.html do
      end
      f.js do
        @ctxt = params[:context].to_s
        send("#{@ctxt}_filter") if @ctxt
        render layout: false
      end
    end
  end

  private
  def theses_filter
    @theses = Diamond::Thesis.include_peripherals.send(params[:filter]).pick_five.let do |t|
      t = send("theses_for_#{current_user_permission(Diamond::Thesis)}_permission", t)
    end
  end

  def theses_for_manage_department_permission(theses_relation)
    theses_relation.by_department(current_user.verifable.department_id)
  end

  def theses_for_manage_own_permission(theses_relation)
    theses_relation.by_supervisor(current_user.verifable_id)
  end

  def theses_for_manage_permission(theses_relation)
    theses_relation
  end

end
