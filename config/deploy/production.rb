role :app, %w{dyplomy.gorn.agh.edu.pl}
role :web, %w{dyplomy.gorn.agh.edu.pl}
role :db,  %w{dyplomy.gorn.agh.edu.pl}
role :resque_worker, %w{dyplomy.gorn.agh.edu.pl}
role :resque_scheduler, %w{dyplomy.gorn.agh.edu.pl}


set :deploy_to, "/var/www/szs"
set :rvm_ruby_version, '2.0.0@usi'
set :rails_env, "production"

server 'dyplomy.gorn.agh.edu.pl', user: 'deploy', roles: %w{web app}

set :ssh_options, {
  forward_agent: true
}