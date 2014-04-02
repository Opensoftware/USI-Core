ActiveRecord::Base.transaction do

  I18n.locale = :pl

  Annual.create!(:name => "2014-2015")

  perm = Permission.new(subject_class: "all", action: "manage")
  perm.save!

  role = Role.create!(:name => "Superadmin")
  role.permissions << perm
  role.save!

  Role.create!(:name => "Anonymouse")
  Role.create!(:name => "Student")
  Role.create!(:name => "Administrator katedralny")
  Role.create!(:name => "Pracownik dziekanatu")
  Role.create!(:name => "Pracownik naukowy")

  user = User.new
  user.email = "admin@opensoftware.pl"
  user.password = '123qweasdzxc'
  user.password_confirmation = '123qweasdzxc'
  user.role_id =  Role.where(:name => "Superadmin").first.id
  user.save!
  user.silent_activate!

end
