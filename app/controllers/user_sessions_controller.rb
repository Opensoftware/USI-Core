class UserSessionsController < ApplicationController

  skip_authorization_check :only => [:new, :create, :destroy]

  def new
    if current_user
      redirect_to root_url
      return
    end
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      if session[:requested_url].present?
        requested_url = session[:requested_url]
        session[:requested_url] = nil
        redirect_to requested_url
      else
        redirect_to dashboard_index_url
      end
    else
      render :action => 'new'
    end
  end

  def destroy
    @user_session = UserSession.find(params[:id])
    unless @user_session.nil?
      @user_session.destroy
    end
    flash[:notice] = t(:label_logout_correctly)
    redirect_to root_url
  end
end
