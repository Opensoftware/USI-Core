# Sample employees, students and theses

ActiveRecord::Base.transaction do

  I18n.locale = :pl
  pl_lang = Language.where(code: I18n.locale).first
  annual = Annual.where(name: "2014-2015").first

  employee_role = Role.where(:name => "Promotor").first
  student_role = Role.where(:name => "Student").first
  faculty_admin_role = Role.where(:name => "Administrator wydziałowy").first
  department_admin_role = Role.where(:name => "Administrator katedralny").first

  thesis_type1 = Diamond::ThesisType.find(1)
  thesis_type2 = Diamond::ThesisType.find(2)

  faculty = Faculty.where(short_name: 'GiG', code: 'G', name: 'Górnictwa i Geoinżynierii').first
  course1 = Course.where(short_name: 'GG', code: 'GG', name: 'Górnictwo i Geologia').first
  course2 = Course.where(short_name: 'BG', code: 'BG', name: 'Budownictwo').first
  course3 = Course.where(short_name: 'IS', code: 'IS', name: 'Inżynieria Środowiska').first
  course4 = Course.where(short_name: 'IP', code: 'IP', name: 'Zarządzanie i Inżynieria Produkcji').first

  department1 = Department.where(short_name: "EiZwP", code: "E", name: "Ekonomiki i Zarządzania w Przemyśle").first
  department2 = Department.where(short_name: "GBiG", code: "G", name: "Geomechaniki, Budownictwa i Geotechniki").first

  studies1 = Studies.create!(course_id: course1.id, study_type_id: StudyType.first.id, study_degree_id: StudyDegree.first.id)

  user = User.new
  user.email = "szef@at.edu"
  user.password = '123qweasdzxc'
  user.password_confirmation = '123qweasdzxc'
  user.role = faculty_admin_role
  user.save!
  user.silent_activate!
  employee = Employee.new(surname: "Szef", name: "Anna", room: "123", academy_unit_id: faculty.id, employee_title_id: EmployeeTitle.first.id, language_id: pl_lang.id)
  user.verifable = employee
  user.save!

  user = User.new
  user.email = "kierownik@at.edu"
  user.password = '123qweasdzxc'
  user.password_confirmation = '123qweasdzxc'
  user.role = department_admin_role
  user.save!
  user.silent_activate!
  employee = Employee.new(surname: "Kierownik", name: "Bożydar", room: "123", academy_unit_id: department1.id, employee_title_id: EmployeeTitle.first.id, language_id: pl_lang.id, department_id: department1.id)
  user.verifable = employee
  user.save!

  user = User.new
  user.email = "nadsztygar@at.edu"
  user.password = '123qweasdzxc'
  user.password_confirmation = '123qweasdzxc'
  user.role = department_admin_role
  user.save!
  user.silent_activate!
  employee = Employee.new(surname: "Nadsztygar", name: "Włodzimierz", room: "123", academy_unit_id: department2.id, employee_title_id: EmployeeTitle.first.id, language_id: pl_lang.id, department_id: department2.id)
  user.verifable = employee
  user.save!

  user = User.new
  user.email = "torpeda@at.edu"
  user.password = '123qweasdzxc'
  user.password_confirmation = '123qweasdzxc'
  user.role = employee_role
  user.save!
  user.silent_activate!
  employee = Employee.new(surname: "Torpeda", name: "Andrzej", room: "123", www: 'www.wp.pl', academy_unit_id: department2.id, employee_title_id: EmployeeTitle.first.id, language_id: pl_lang.id, department_id: department2.id)
  user.verifable = employee
  user.save!

  user = User.new
  user.email = "bomba@at.edu"
  user.password = '123qweasdzxc'
  user.password_confirmation = '123qweasdzxc'
  user.role = employee_role
  user.save!
  user.silent_activate!
  employee2 = Employee.new(surname: "Bomba", name: "Mieczysław", room: "234", www: 'www.wp.pl', academy_unit_id: department1.id, employee_title_id: EmployeeTitle.first.id, language_id: pl_lang.id, department_id: department1.id )
  user.verifable = employee2
  user.save!

  user = User.new
  user.email = "traba@at.edu"
  user.password = '123qweasdzxc'
  user.password_confirmation = '123qweasdzxc'
  user.role = student_role
  user.save!
  user.silent_activate!
  student1 = Student.new(surname: "Trąba", name: "Krzysztof", language_id: pl_lang.id, index_number: 123456 )
  user.verifable = student1
  user.save!
  student1.student_studies << StudentStudies.new(studies: studies1 , semester_number: 4)


  user = User.new
  user.email = "babel@at.edu"
  user.password = '123qweasdzxc'
  user.password_confirmation = '123qweasdzxc'
  user.role = student_role
  user.save!
  user.silent_activate!
  student2 = Student.new(surname: "Bąbel", name: "Roman", language_id: pl_lang.id, index_number: 345678 )
  user.verifable = student2
  user.save!
  student2.student_studies << StudentStudies.new(studies: studies1 , semester_number: 4)

  user = User.new
  user.email = "kolo@at.edu"
  user.password = '123qweasdzxc'
  user.password_confirmation = '123qweasdzxc'
  user.role = student_role
  user.save!
  user.silent_activate!
  student3 = Student.new(surname: "Koło", name: "Michał", language_id: pl_lang.id, index_number: 456832 )
  user.verifable = student3
  user.save!
  student3.student_studies << StudentStudies.new(studies: studies1 , semester_number: 4)


  thesis = Diamond::Thesis.new(title: "Nowa metoda poszukiwania wody w studni", description: "Praca będzie polegać na opracowaniu nowej metody poszukiwania wody w studni", thesis_type: thesis_type1, supervisor_id: employee.id, annual_id: annual.id, department_id: department1.id)
  thesis.save!
  thesis.courses << [course2, course3]
  thesis = Diamond::Thesis.new(title: "Kombajnowanie kopalni", description: "Praca będzie polegać na opracowaniu na wjechaniu kombajnem do kopalni", thesis_type: thesis_type2, supervisor_id: employee2.id, annual_id: annual.id, department_id: department1.id)
  thesis.save!
  thesis.courses << [course1, course4]
  thesis = Diamond::Thesis.new(title: "Kopanie w kopalni", description: "Praca będzie polegać na opracowaniu na kopaniu w kopalni", thesis_type: thesis_type1, supervisor_id: employee.id, annual_id: annual.id, department_id: department1.id)
  thesis.save!
  thesis.courses << [course1, course3]
  thesis = Diamond::Thesis.new(title: "Wpływ parametrów geomechanicznych skał na dobór obudowy wyrobisk korytarzowych", description: "Praca będzie polegać na wyznaczeniu parametrów geomechanicznych skał na dobór obudowy wyrobisk korytarzowych", thesis_type: thesis_type1, supervisor_id: employee.id, annual_id: annual.id, department_id: department2.id, state: :published)
  thesis.save!
  thesis.courses << [course1]
  thesis = Diamond::Thesis.new(title: "Analiza możliwości dostosowania górniczych przepisów bhp w podziemnych zakładach górniczych do specyficznych warunków technicznych drążenia tueli z zastosowaniem techniki górniczej", description: "Praca będzie polegać na analizowaniu właściwości. Praca będzie polegać na analizowaniu właściwości. Praca będzie polegać na analizowaniu właściwości. Praca będzie polegać na analizowaniu właściwości. Praca będzie polegać na analizowaniu właściwości. ", thesis_type: thesis_type2, supervisor_id: employee.id, annual_id: annual.id, department_id: department2.id, state: :published)
  thesis.save!
  thesis.courses << [course1]
  thesis = Diamond::Thesis.new(title: "Program komputerowy do analizy stateczności wyrobisk w masywie skalnym o strukturze blokowej metodą Goodmana i Shi", description: "Napisać program, trzeba umieć programować.", thesis_type: thesis_type2, supervisor_id: employee.id, annual_id: annual.id, department_id: department2.id, state: :published)
  thesis.save!
  thesis.courses << [course3]
end
