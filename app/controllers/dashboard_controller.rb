class DashboardController < ApplicationController

  def index
    authorize! :read, User

    if current_user.student?
      @enrollments = current_user.student.enrollments.includes(:thesis)
    end
  end

end
