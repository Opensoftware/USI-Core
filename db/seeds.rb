ActiveRecord::Base.transaction do

  I18n.locale = :pl

  Language.create!(:name_pl => "Polski", :name_en => 'Polish', :code => 'pl')
  Language.create!(:name_pl => "Angielski", :name_en => 'English', :code => 'en')

  annual = Annual.new(name: "2014-2015")
  annual.save!
  semester = EnrollmentSemester.new(annual_id: annual.id,
    thesis_enrollments_begin: DateTime.new(2014,5,15),
    thesis_enrollments_end: DateTime.new(2014,5,30),
    elective_enrollments_begin: DateTime.new(2014,6,15),
    elective_enrollments_end: DateTime.new(2014,6,21))
  semester.save!
  settings = Settings.new(current_annual_id: annual.id, current_semester_id: semester.id)
  settings.save!

  StudyDegree.create!(:name_pl => "Studia I stopnia", :code => "1", :name_en => "First-cycle studies", short_name_pl: 'I', short_name_en: 'First-cycle')
  StudyDegree.create!(:name_pl => "Studia II stopnia", :code => "2", :name_en => "Second-cycle studies", short_name_pl: 'II', short_name_en: 'Second-cycle')
  StudyDegree.create!(:name_pl => "Studia III stopnia", :code => "3", :name_en => "Third-cycle studies", short_name_pl: 'III', short_name_en: 'Third-cycle')


  StudyType.create!(:name => "Stacjonarne", :code => "S")
  StudyType.create!(:name => "Niestacjonarne", :code => "N")
  StudyType.create!(:name => "Wieczorowe", :code => "W")

  employee_titles = [ {:name => "dr" },
    {:name => "dr hab." },
    {:name => "dr hab. inż." },
    {:name => "dr inż." },
    {:name => "dr inż. architekt" },
    {:name => "dr n. techn. lek. med." },
    {:name => "dypl. ek." },
    {:name => "inż." },
    {:name => "lek. med." },
    {:name => "licencjat" },
    {:name => "mgr" },
    {:name => "mgr inż." },
    {:name => "mgr inż. architekt" },
    {:name => "prof." },
    {:name => "prof. dr hab." },
    {:name => "prof. dr hab. inż." },
    {:name => "prof. dr inż." },
    {:name => "prof. nadzw. dr hab." },
    {:name => "prof. nadzw. dr hab. inż." },
    {:name => "prof. zw. dr hab." },
    {:name => "prof. zw. dr hab. inż." },
    {:name => "prof. zw. dr inż." }
  ]

  employee_titles.each do |title|
    EmployeeTitle.create!(title)
  end

  perm = Permission.new(subject_class: "all", action: "manage")
  perm.save!

  superadmin_role = Role.create!(:name => "Superadmin")
  superadmin_role.permissions << perm
  superadmin_role.save!

  Role.create!(:name => "Anonymouse")
  Role.create!(:name => "Student")
  Role.create!(:name => "Administrator katedralny")
  Role.create!(:name => "Pracownik dziekanatu")
  role = Role.new(:name => "Promotor")
  role.save!

  user = User.new
  user.email = "admin@opensoftware.pl"
  user.password = '123qweasdzxc'
  user.password_confirmation = '123qweasdzxc'
  user.role = superadmin_role
  user.save!
  user.silent_activate!

  if defined? Diamond
    Diamond::ThesisType.create!(name_pl: "Praca Inżynierska", name_en: "Engineering Thesis", short_name_pl: "Inż", short_name_en: "BSc")
    Diamond::ThesisType.create!(name_pl: "Praca Magisterska", name_en: "Master Thesis", short_name_pl: "Mgr", short_name_en: "MSc")
    Diamond::ThesisType.create!(name_pl: "Praca Licencjacka", name_en: "Licentiate thesis", short_name_pl: "Lic", short_name_en: "Lic")
  end

end
