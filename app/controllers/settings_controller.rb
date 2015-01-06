class SettingsController < ApplicationController

  authorize_resource :settings, :class_name => "Settings"

  def edit
    @annuals = Annual.all
  end

  def update
    setting = Settings.find(params[:id])
    result = Settings::UpdateSettingsBatch
    .call(settings_params: settings_params,
          setting: setting,
          current_annual: current_annual)

    if result.success?
      redirect_to root_url
    end
  end

  private

  def settings_params
    params.require(:settings).permit(
      [:welcome_text, :current_annual_id,
       enrollment_semester_attributes: [:id, :thesis_enrollments_begin,
                                        :thesis_enrollments_end,
                                        :elective_enrollments_begin,
                                        :elective_enrollments_end]]
    )
  end

end
