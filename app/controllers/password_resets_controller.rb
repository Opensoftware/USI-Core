class PasswordResetsController < ApplicationController

  before_filter :load_user_using_perishable_token, :only => [:edit, :update]

  skip_authorization_check

  def new
  end

  def create
    @user = User.where(email: params[:email]).first
    if @user
      @user.deliver_password_reset_instructions!
      flash[:notice] = t(:label_lost_password_instructions)
      redirect_to root_url
    else
      flash.now[:error] = t(:label_lost_password_email_not_found)
      render :action => :new
    end
  end

  def edit
    render
  end

  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      flash[:notice] = t(:label_lost_password_updated)
      redirect_to user_url(@user)
    else
      render :action => :edit
    end
  end

  private
  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:notice] = t(:label_lost_password_token_not_found)
      redirect_to root_url
    end
  end

end
