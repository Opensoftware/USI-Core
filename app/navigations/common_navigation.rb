if defined?(current_user)
  SimpleNavigation::Configuration.run do |navigation|
    navigation.items do |primary|
      primary.dom_class = 'nav navbar-nav'
      primary.item :nav, "<i class='icon icon-white icon-elective-blocks'></i> #{t(:label_elective_block_plural)}", ''
      primary.item :nav, "<i class='icon icon-white icon-thesis-list'></i> #{t(:label_thesis_plural_official)}", diamond.theses_path
      if current_user
        primary.item :user_account, "<i class='icon icon-white icon-user'></i> #{current_user.verifable.surname_name}", main_app.user_path(current_user) do |primary|
          primary.item :nav, t(:label_account_settings), main_app.user_path(current_user)
          primary.item :nav, t(:label_deadline_plural), main_app.edit_enrollment_semester_path(current_semester), :if => lambda { can?(:manage, current_semester) }
          primary.item :logout, t(:label_logout), main_app.logout_path, method: :delete
        end
      else
        primary.item :login, I18n.t(:label_login), main_app.new_user_session_path
      end
    end
  end
end
