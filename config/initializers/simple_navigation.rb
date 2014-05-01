paths = [File.join(Rails.root, 'app', 'navigations')]
SimpleNavigation.config_file_paths = paths
#SimpleNavigation.register_renderer :listwithspan => ListWithSpan
#SimpleNavigation.register_renderer :image => TooltipImagesMenu
#SimpleNavigation.register_renderer :custom_breadcrumbs => CustomBreadcrumbs
SimpleNavigation.config.active_leaf_class = "active"
SimpleNavigation.register_renderer :custom_breadcrumbs => CustomBreadcrumbs