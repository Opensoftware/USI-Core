class DashboardController < ApplicationController

  def index
    authorize! :read, User

    if current_user.student?
      @enrollments = current_user.student.thesis_enrollments.includes(:thesis)
    elsif current_user.employee?

      if can?(:manage, Diamond::Thesis)
      elsif can?(:manage_department, Diamond::Thesis)
        @enrollment_messages = Diamond::ThesisMessage.for_enrollment.for_employee(current_user)
        .paginate(:page => params[:page].to_i < 1 ? 1 : params[:page], :per_page => params[:per_page].to_i < 1 ? 10 : params[:per_page])
        @department_theses = Diamond::Thesis.by_annual(current_annual).by_department(current_user.verifable.department_id).count
        load_statistics(:by_department, current_user.verifable.department_id)
      elsif can?(:manage_own, Diamond::Thesis)
        @enrollment_messages = Diamond::ThesisMessage.for_enrollment.for_employee(current_user)
        .paginate(:page => params[:page].to_i < 1 ? 1 : params[:page], :per_page => params[:per_page].to_i < 1 ? 10 : params[:per_page])
        @thesis_state_messages = Diamond::ThesisMessage.for_thesis_state.for_employee(current_user)
        .paginate(:page => params[:page].to_i < 1 ? 1 : params[:page], :per_page => params[:per_page].to_i < 1 ? 10 : params[:per_page])
        load_statistics(:by_supervisor, current_user.verifable_id)
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
  def load_statistics(method, *args)
    @proposed_theses = Diamond::Thesis.by_annual(current_annual).send(method, args).count
    @accepted_theses = Diamond::Thesis.by_annual(current_annual).send(method, args).visible.count
    @unaccepted_theses = Diamond::Thesis.by_annual(current_annual).send(method, args).unaccepted.count
    @not_chosen_theses = Diamond::Thesis.by_annual(current_annual).send(method, args).recently_accepted.count
    @chosen_theses = Diamond::Thesis.by_annual(current_annual).send(method, args).assigned.count
  end

  def theses_filter
    thesis_ids = Diamond::Thesis.send(params[:filter]).let do |t|
      t = send("theses_for_#{current_user_permission(Diamond::Thesis)}_permission", t)
      unless t.kind_of?(Array)
        t = t.pick_five
      end
      t
    end
    @theses = Diamond::Thesis.include_peripherals.where(id: thesis_ids)
  end

  def theses_for_manage_department_permission(theses_relation)
    if theses_relation.kind_of?(Array)
      Diamond::Thesis.department_newest_enrollments(current_user.verifable)
    else
      theses_relation.by_department(current_user.verifable.department_id)
    end
  end

  def theses_for_manage_own_permission(theses_relation)
    if theses_relation.kind_of?(Array)
      Diamond::Thesis.supervisor_newest_enrollments(current_user.verifable)
    else
      theses_relation.by_supervisor(current_user.verifable_id)
    end
  end

  def theses_for_manage_permission(theses_relation)
    theses_relation
  end

end
