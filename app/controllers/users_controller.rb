class UsersController < ApplicationController

  authorize_resource

  def index
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
    @employee_titles = EmployeeTitle.all
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
    permit_params = [:email, :notifications_confirmation].let do |p|
      if can?(:manage, Employee)
        p << :role_id
        p << {:employee_attributes => [:id, :building_id, :department_id,
            :academy_unit_id, :employee_title_id]}
      end
      p
    end
    params.require(:user).permit(permit_params)
  end
end
