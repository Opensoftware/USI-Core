ActiveRecord::Base.transaction do

  I18n.locale = :pl
  pl_lang = Language.where(code: I18n.locale).first
  annual = Annual.where(name: "2014-2015").first

  employee_role = Role.where(:name => "Pracownik naukowy").first


  base_unit = AcademyUnit.new(short_name: 'AT', code: 'AT',
                              name: 'Akademia Techniczna')
  base_unit.save!

  faculty = Faculty.new(short_name: 'G', code: 'G',
                        name: 'Górniczy',
                        overriding_id: base_unit.id)
  faculty.save!

  Building.create(short_name: 'A4', code: 'A4', name: 'A4', overriding_id: faculty.id)

  Course.create(short_name: 'GG', code: 'GG', name: 'Górnictwo', academy_unit_id: faculty.id)
  Course.create(short_name: 'HU', code: 'HU', name: 'Hutnictwo', academy_unit_id: faculty.id)
  Course.create(short_name: 'SZ', code: 'SZ', name: 'Szklarnictwo', academy_unit_id: faculty.id)
  Course.create(short_name: 'ZL', code: 'ZL', name: 'Złotnictwo', academy_unit_id: faculty.id)

  user = User.new
  user.email = "torpeda@at.edu"
  user.password = '123qweasdzxc'
  user.password_confirmation = '123qweasdzxc'
  user.role = employee_role
  user.save!
  user.silent_activate!
  employee = Employee.new(surname: "Torpeda", name: "Andrzej", room: "123",
                          www: 'www.wp.pl', academy_unit_id: faculty.id,
                          employee_title_id: EmployeeTitle.first,
                          language_id: pl_lang.id)
  user.verifable = employee
  user.save!

  thesis = Diamond::Thesis.new(title: "Nowa metoda poszukiwania wody w studni",
                               description: "Praca będzie polegać na opracowaniu
                               nowej metody poszukiwania wody w studni",
                               annual_id: annual.id,
                               thesis_type: Diamond::ThesisType.first,
                               supervisor_id: employee.id)
  thesis.save!

end
