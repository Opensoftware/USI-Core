if defined?(current_user)
  SimpleNavigation::Configuration.run do |navigation|
    navigation.items do |primary|
      primary.dom_class = 'context-nav'
      if controller.controller_name =~ /theses/
        case controller.action_name
        when /index/ then
          primary.item :nav, t(:label_list_export), diamond.theses_path, :class => "inline-icon inline-icon-red inline-icon-export" do |navigation|
            navigation.dom_class = 'context-nav'
            navigation.item :nav, I18n.t(:label_list_export_pdf), diamond.theses_path(:format => :pdf)
            navigation.item :nav, I18n.t(:label_list_export_xls), diamond.theses_path(:format => :xlsx)
          end
          primary.item :nav, I18n.t(:label_thesis_new_plural), diamond.new_thesis_path, if: lambda { can?(:create, Diamond::Thesis) }, :class => "inline-icon inline-icon-red inline-icon-plus"
          when /new|edit/ then
            primary.item :nav, I18n.t(:label_move_back), diamond.theses_path, :class => "inline-icon inline-icon-red inline-icon-left-arrow"
          when /show/ then
            primary.item :nav, I18n.t(:label_move_back), diamond.theses_path, :class => "inline-icon inline-icon-red inline-icon-left-arrow"
          end
        elsif controller.controller_name =~ /dashboard/
          case controller.action_name
          when /index/
            if can?(:manage_own, Diamond::Thesis)
              primary.item :nav, I18n.t(:label_thesis_browse_yours), diamond.theses_path(:supervisor_id => current_user.verifable_id), :if => lambda { current_user.verifable.having_any_theses? }, :class => "inline-icon inline-icon-red inline-icon-thesis-list"
              primary.item :nav, I18n.t(:label_thesis_new_plural), diamond.new_thesis_path, :class => "inline-icon inline-icon-red inline-icon-plus"
            elsif current_user.student?
              primary.item :nav, I18n.t(:label_thesis_browse_field_of_study), diamond.theses_path(:course_ids => current_user.verifable.course_ids.first), :class => "inline-icon inline-icon-red inline-icon-thesis-list"
            end
          end
        elsif controller.controller_name =~ /user/
          case controller.action_name
          when /new|edit/
            primary.item :nav, I18n.t(:label_move_back_main_page), root_path, :class => "inline-icon inline-icon-red inline-icon-left-arrow"
          when /show/
            primary.item :nav, I18n.t(:label_edit), edit_user_path(@user), :if => lambda { @user.present? }, :class => "inline-icon inline-icon-red inline-icon-pen"
            primary.item :nav, I18n.t(:label_move_back_main_page), root_path, :class => "inline-icon inline-icon-red inline-icon-left-arrow"
          end
        elsif controller.controller_name =~ /department_settings/
          case controller.action_name
          when /new|edit/
            primary.item :nav, I18n.t(:label_move_back_main_page), root_path, :class => "inline-icon inline-icon-red inline-icon-left-arrow"
          end
        elsif controller.controller_name =~ /employees/
          case controller.action_name
          when /index/
            primary.item :nav, I18n.t(:label_employee_add), main_app.new_employee_path, :class => "inline-icon inline-icon-red inline-icon-plus"
          when /show/
            primary.item :nav, I18n.t(:label_edit), edit_employee_path(@employee), :if => lambda { @employee.present? }, :class => "inline-icon inline-icon-red inline-icon-pen"
            primary.item :nav, I18n.t(:label_move_back_employees), employees_path, :class => "inline-icon inline-icon-red inline-icon-left-arrow"
          end
        elsif controller.controller_name =~ /students/
          case controller.action_name
          when /index/
            primary.item :nav, I18n.t(:label_student_add), main_app.new_student_path, :class => "inline-icon inline-icon-red inline-icon-plus"
          when /show/
            primary.item :nav, I18n.t(:label_edit), edit_student_path(@student), :if => lambda { @student.present? }, :class => "inline-icon inline-icon-red inline-icon-pen"
            primary.item :nav, I18n.t(:label_move_back_students), students_path, :class => "inline-icon inline-icon-red inline-icon-left-arrow"
          when /edit/
            primary.item :nav, I18n.t(:label_move_back_students), students_path, :class => "inline-icon inline-icon-red inline-icon-left-arrow"
          end
        end
      end
    end
  end