class UsersController < ApplicationController

  authorize_resource

  def index
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    authorize! :update, @user

    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :notifications_confirmation)
  end
end
