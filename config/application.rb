require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module UsiCore
  class Application < Rails::Application
    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Warsaw'

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}').to_s]
    config.autoload_paths += %W(#{config.root}/lib)
    config.i18n.default_locale = :pl
    config.encoding = "utf-8"
    config.assets.paths << Rails.root.join("vendor", "assets", "bootstrap")
    config.assets.precompile += %w(enrollment_semester.js filter_form.js main.js student_autocomplete.js
dashboard.js pl_translations.js employee.js supervisor_autocomplete.js list_history.js en_translations.js
  core.engine.js diamond/show_thesis.js diamond/theses_list.js diamond/thesis.js diamond/thesis_menu.js
bootstrap-wysihtml5/bootstrap3-wysihtml5.js bootstrap-wysihtml5/locales/pl-PL.js
bootstrap3-wysihtml5.css base.css student.js)
    config.paths['db/migrate'] << '../diamond/db/migrate/' if defined?(Diamond)
    config.paths['db/migrate'] << '../graphite/db/migrate/' if defined?(Graphite)
    config.paths['db/migrate'] << '../pyrite/db/migrate/' if defined?(Pyrite)
    config.preload_frameworks = true
    config.allow_concurrency = true

  end
end
