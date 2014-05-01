Permission.transaction do

  permission = Permission.new(:subject_class => "Diamond::Thesis", :action => :manage_own)
  permission.condition = "{:supervisor_id => user.verifable_id}"
  permission.save!

  permissions_roles = {
    'promotor' => {
      "User"=>["read"],
      "Diamond::Thesis"=>["manage_own"]
    },
    'student' => {
      "User"=>["read"],
      "Diamond::Thesis"=>["read"],
      "Diamond::ThesisEnrollment"=>["create"]
    },
    'pracownik dziekanatu' => {
      "User"=>["manage"],
      "Diamond::Thesis"=>["manage"],
      "Diamond::ThesisEnrollment"=>["manage"],
      'EnrollmentSemester'=>["manage"]
    }
  }

  permissions_roles.each do |role_name, permissions|
    role = Role.where('LOWER(name) = ?', role_name).first
    if role.present?
      permissions.each do |subject_class, actions|
        actions.each do |action|
          perm = Permission.where(subject_class: subject_class, action: action).first
          if perm.present?
            role.permissions << perm
          end
        end
      end
    end
  end
end