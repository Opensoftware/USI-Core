class SettingsController < ApplicationController

  authorize_resource :settings, :class_name => "Settings"

  def update
    setting = Settings.find(params[:id])
    if setting.update(settings_params)
      redirect_to root_url
    end
  end

  private

  def settings_params
    params.require(:settings).permit([:welcome_text])
  end
  
end
