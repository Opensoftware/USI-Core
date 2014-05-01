class BaseController < ApplicationController

  def index
    @user_session = UserSession.new
  end

end
