class DashboardController < ApplicationController

  def index
    authorize! :read, User

    if current_user.student?
      @enrollments = current_user.student.enrollments.includes(:thesis)
    elsif current_user.employee?
      @theses = Diamond::Thesis.by_supervisor(current_user.verifable_id).newest.limit(5)
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
