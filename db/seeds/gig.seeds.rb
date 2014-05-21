ActiveRecord::Base.transaction do

  I18n.locale = :pl
  annual = Annual.where(name: "2014-2015").first

  base_unit = AcademyUnit.new(short_name: 'AT', code: 'AT', name: 'Akademia Górniczo-Hutnicza')
  base_unit.save!

  faculty = Faculty.new(short_name: 'GiG', code: 'G', name: 'Górnictwa i Geoinżynierii', overriding_id: base_unit.id, annual_id: annual.id)
  faculty.save!
  faculty1 = Faculty.new(short_name: 'NiG', code: 'W', name: 'Nafty i Gazu', overriding_id: base_unit.id, annual_id: annual.id)
  faculty1.save!

  department1 = Department.new(short_name: "EiZwP", code: "E", name: "Ekonomiki i Zarządzania w Przemyśle", overriding_id: faculty.id)
  department1.save!
  department2 = Department.new(short_name: "GBiG", code: "G", name: "Geomechaniki, Budownictwa i Geotechniki", overriding_id: faculty.id)
  department2.save!
  department3 = Department.new(short_name: "GBiG", code: "O", name: "Górnictwa Odkrywkowego", overriding_id: faculty.id)
  department3.save!
  department4 = Department.new(short_name: "GP", code: "P", name: "Górnictwa Podziemnego", overriding_id: faculty.id)
  department4.save!
  department4 = Department.new(short_name: "ISiPS", code: "I", name: "Inżynierii Środowiska i Przeróbki Surowców", overriding_id: faculty.id)
  department4.save!


  building = Building.new(short_name: 'A4', code: 'A4', name: 'A4', overriding_id: faculty.id)
  building.save!
  building = Building.new(short_name: 'A3', code: 'A3', name: 'A3', overriding_id: faculty.id)
  building.save!

  course1 = Course.new(short_name: 'GG', code: 'GG', name: 'Górnictwo i Geologia', academy_unit_id: faculty.id)
  course1.save!
  course2 = Course.new(short_name: 'BG', code: 'BG', name: 'Budownictwo', academy_unit_id: faculty.id)
  course2.save!
  course3 = Course.new(short_name: 'IS', code: 'IS', name: 'Inżynieria Środowiska', academy_unit_id: faculty.id)
  course3.save!
  course4 = Course.new(short_name: 'IP', code: 'IP', name: 'Zarządzanie i Inżynieria Produkcji', academy_unit_id: faculty.id)
  course4.save!

end
