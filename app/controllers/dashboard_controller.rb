class DashboardController < ApplicationController

  def index
    authorize! :read, User


    @dashboard_presenter = Dashboard
    .const_get("#{current_user.role.const_name}_presenter".camelize)
    .new(self)

    respond_to do |f|
      f.html do
      end
      f.js do
        render layout: false
      end
    end
  end
end
