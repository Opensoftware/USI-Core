if defined?(current_user)
  SimpleNavigation::Configuration.run do |navigation|
    navigation.items do |primary|
      primary.item :nav, I18n.t(:label_dashboard_short), main_app.dashboard_index_path, :if => lambda {params[:controller] =~ /dashboard/ && current_user} do |navigation|
        if can?(:manage_own, Diamond::Thesis)
          navigation.item :nav, I18n.t(:label_thesis_browse_yours), diamond.theses_path(:supervisor_id => current_user.verifable_id), :if => lambda { current_user.verifable.having_any_theses? }, :class => "inline-icon inline-icon-red inline-icon-thesis-list"
          navigation.item :nav, I18n.t(:label_thesis_new_plural), diamond.new_thesis_path, :class => "inline-icon inline-icon-red inline-icon-plus"
        end
      end
      primary.item :nav, '', diamond.theses_path, :if => lambda {params[:action] =~ /index/} do |navigation|
        navigation.item :nav, I18n.t(:label_list_export_pdf), diamond.new_thesis_path(:format => :pdf), :class => "inline-icon inline-icon-red inline-icon-export"
        navigation.item :nav, I18n.t(:label_list_export_xls), diamond.new_thesis_path(:format => :xlsx), :class => "inline-icon inline-icon-red inline-icon-export"
        navigation.item :nav, I18n.t(:label_thesis_new_plural), diamond.new_thesis_path, :if => lambda { current_user && can?(:manage_own, Diamond::Thesis) }, :class => "inline-icon inline-icon-red inline-icon-plus"
      end
      primary.item :nav, '', diamond.new_thesis_path, :if => lambda {params[:controller] =~ /theses/} do |navigation|
        navigation.item :nav, I18n.t(:label_move_back), diamond.theses_path, :class => "inline-icon inline-icon-red inline-icon-left-arrow"
      end
      primary.item :nav, '', main_app.edit_enrollment_semester_path(current_semester), :if => lambda {params[:controller] =~ /enrollment_semesters/} do |navigation|
        navigation.item :nav, I18n.t(:label_move_back_main_page), main_app.dashboard_index_path, :if => lambda {current_user}, :class => "inline-icon inline-icon-red inline-icon-left-arrow"
      end

    end
  end
end