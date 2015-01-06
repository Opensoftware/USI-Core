class Settings::UpdateSettingsBatch

  include Interactor::Organizer

  organize Settings::UpdateSettings, Settings::CreateDepartmentSettings

end
