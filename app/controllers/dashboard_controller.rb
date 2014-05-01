class DashboardController < ApplicationController

  def index
    authorize! :read, User
  end

end
