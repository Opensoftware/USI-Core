role :app, %w{opensoftware.pl}
role :web, %w{opensoftware.pl}
role :db,  %w{opensoftware.pl}
role :resque_worker, %w{opensoftware.pl}
role :resque_scheduler, %w{opensoftware.pl}

set :deploy_to, "/home/www/rails_app/usi-demo"
set :rvm_ruby_version, '2.0.0@usi-demo'
set :rails_env, "test"

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

server 'opensoftware.pl', user: 'rails', roles: %w{web app}
