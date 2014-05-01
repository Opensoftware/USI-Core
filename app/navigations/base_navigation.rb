if defined?(current_user)
  SimpleNavigation::Configuration.run do |navigation|
    engines = Rails::Engine.subclasses.map(&:instance).select do |e|
      e.respond_to?(:navigation)
    end
    navigation.items do |primary|
      primary.item :nav, I18n.t(:label_dashboard_short), main_app.dashboard_index_path
      primary.item :nav, I18n.t(:label_home_page), main_app.root_path do |primary|
        engines.each do |e|
          e.navigation(primary, self)
        end
      end
    end
  end
end
