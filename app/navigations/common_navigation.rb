if defined?(current_user)
  SimpleNavigation::Configuration.run do |navigation|
    navigation.items do |primary|
      primary.dom_class = 'nav navbar-nav'
      if can?(:manage, Employee) || can?(:manage, Student)
        primary.item :nav, "<i class='icon icon-white icon-users'></i> #{t(:label_users_plural)}", '' do |nav|
          nav.item :nav, t(:label_employee_plural), main_app.employees_path, :if => lambda { can?(:manage, Employee) }
          nav.item :nav, t(:label_student_plural), main_app.students_path, :if => lambda { can?(:manage, Student) }
        end
      end
      if current_user
        primary.item :nav, "<i class='icon icon-white icon-elective-blocks'></i> #{t(:label_elective_block_plural)}", graphite.elective_blocks_path,
          :if => lambda { can?(:manage, Graphite::ElectiveBlock) }
      end
      primary.item :nav, "<i class='icon icon-white icon-thesis-list'></i> #{t(:label_thesis_plural_official)}", diamond.theses_path
      if current_user
        primary.item :user_account, "<i class='icon icon-white icon-user'></i> #{current_user.verifable.surname_name}", main_app.user_path(current_user) do |primary|
          primary.item :nav, t(:label_account_settings), main_app.edit_user_path(current_user)
          primary.item :nav, t(:label_deadline_plural), main_app.edit_setting_path(current_settings), :if => lambda { can?(:manage, current_semester) }
          if department_settings
            primary.item :nav, t(:label_thesis_plural_count), main_app.edit_department_setting_path(department_settings), :if => lambda { can?(:manage, DepartmentSettings) }
          end
          primary.item :logout, t(:label_logout), main_app.logout_path, method: :delete
        end
      else
        primary.item :login, I18n.t(:label_login), main_app.new_user_session_path
      end
    end
  end
end
