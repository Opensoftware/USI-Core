class DepartmentSettingsController < ApplicationController

  authorize_resource :class => "DepartmentSettings"

  def edit
    @department_settings = DepartmentSettings.find(params[:id])

  end

  def update
    @department_settings = DepartmentSettings.find(params[:id])

    if @department_settings.update(department_settings_params)
      redirect_to dashboard_index_path
    else
      render 'edit'
    end
  end

  private
  def department_settings_params
    params.require(:department_settings).permit(:max_theses_count)
  end

end
