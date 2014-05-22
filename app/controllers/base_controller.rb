class BaseController < ApplicationController

  skip_authorization_check :only => [:index]

  def index
    @user_session = UserSession.new
  end

end
