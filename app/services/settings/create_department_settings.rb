class Settings::CreateDepartmentSettings

  include Interactor

  def call

    unless DepartmentSettings.for_annual(context.current_annual).exists?
      Department.all.each do |department|
        DepartmentSettings.create(department_id: department.id,
                                  annual_id: context.current_annual.id,
                                  max_theses_count: 15)
      end
    end
  end

end
