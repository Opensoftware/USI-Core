class Settings::UpdateSettings

  include Interactor

  def call

    unless context.setting.update(context.settings_params)
      context.fail!
    end
  end
end
