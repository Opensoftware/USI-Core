class DashboardController < ApplicationController

  authorize_resource :user, :only => [:index], :parent => false

  def index
  end

end
