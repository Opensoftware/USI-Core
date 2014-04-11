require 'permissions_initializr'

namespace :usi_core do

    desc "Creates cancan based permissions for app/controllers"
    task :permissions => :environment do
        include PermissionsInitializr
        setup_actions_controllers_db
        puts "Permissions migration ended successfully."
    end

end