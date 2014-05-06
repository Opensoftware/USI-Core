class DashboardController < ApplicationController

  def index
    authorize! :read, User

    if current_user.student?
      @enrollments = current_user.student.enrollments.includes(:thesis)
    elsif current_user.employee?

      if can?(:manage, Diamond::Thesis)
        @theses = Diamond::Thesis.by_department(current_user.verifable.department).newest.limit(5)
        @enrollment_messages = Diamond::ThesisMessage.for_enrollment.for_department(current_user.verifable)
        .paginate(:page => params[:page].to_i < 1 ? 1 : params[:page], :per_page => params[:per_page].to_i < 1 ? 10 : params[:per_page])
        @thesis_state_messages = Diamond::ThesisMessage.for_thesis_state.for_department(current_user.verifable)
        .paginate(:page => params[:page].to_i < 1 ? 1 : params[:page], :per_page => params[:per_page].to_i < 1 ? 10 : params[:per_page])
      else
        @theses = Diamond::Thesis.by_supervisor(current_user.verifable_id).newest.limit(5)
        @enrollment_messages = Diamond::ThesisMessage.for_enrollment.for_employee(current_user.verifable)
        .paginate(:page => params[:page].to_i < 1 ? 1 : params[:page], :per_page => params[:per_page].to_i < 1 ? 10 : params[:per_page])
        @thesis_state_messages = Diamond::ThesisMessage.for_thesis_state.for_employee(current_user.verifable)
        .paginate(:page => params[:page].to_i < 1 ? 1 : params[:page], :per_page => params[:per_page].to_i < 1 ? 10 : params[:per_page])
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
      t = t.by_supervisor(current_user.verifable_id) if cannot?(:manage, Diamond::Thesis)
    end
  end

end
