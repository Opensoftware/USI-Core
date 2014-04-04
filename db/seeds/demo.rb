ActiveRecord::Base.transaction do

  I18n.locale = :pl
  pl_lang = Language.where(code: I18n.locale).first

  annual = Annual.new("2014-2015")
  annual.save!

  base_unit = AcademyUnit.new(short_name: 'AT', code: 'AT',
                              name: 'Akademia Techniczna')
  base_unit.save!

  faculty = Faculty.new(short_name: 'G', code: 'G', name: 'Górniczy',
                        overriding_id: base_unit.id)
  faculty.save!

  building = Building.new(short_name: 'A4', code: 'A4', name: 'A4',
                          overriding_id: faculty.id)
  building.save!

  course = Course.new(short_name: 'GG', code: 'GG', name: 'Górnictwo',
                      academy_unit_id: faculty.id)
  course.save!

  employee = Employee.new(surname: "Torpeda", name: "Andrzej", room: "123", www:
                          'www.wp.pl', academy_unit_id: faculty.id,
                          employee_title_id: EmployeeTitle.first,
                          language_id: pl_lang.id)
  employee.save!

  thesis = Diamond::Thesis.new(title: "Nowa metoda poszukiwania wody w studni",
                               description: "Praca będzie polegać na opracowaniu
                               nowej metody poszukiwania wody w studni",
                               annual_id: annual.id,
                               thesis_type: Diamond::ThesisType.first)
  thesis.save!

end
