# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'USI-Demo'
set :repo_url, 'ssh://gerrit.opensoftware.pl/usi/core'
set :branch, 'master'
set :deploy_via, :remote_cache
set :format, :pretty
set :log_level, :debug
set :pty, true
set :use_sudo, false
set :deploy_to, "/home/www/rails_app/usi-demo"
set :scm, :git
set :rails_env, "test"

#Resque
set :workers, { :msg => 1 }
set :resque_environment_task, true

# Until we will release engines public we have to point to them here
set :diamond_url, 'ssh://gerrit.opensoftware.pl/usi/diamond'
set :diamond_branch, 'master'
set :graphite_url, 'ssh://gerrit.opensoftware.pl/usi/graphite'
set :graphite_branch, 'master'

# RVM

set :rvm_type, :user
set :rvm_ruby_version, '2.0.0@usi-demo'
set :default_env, { rvm_bin_path: '~/.rvm/bin' }

# Bundler

set :bundle_gemfile, -> { release_path.join('Gemfile') }
set :bundle_dir, -> { shared_path.join('bundle') }
set :bundle_flags, '--deployment'
set :bundle_without, "development"
set :bundle_binstubs, -> { shared_path.join('bin') }
set :bundle_roles, :all
set :keep_releases, 3
set :linked_dirs, %w{tmp/pids}
set :linked_files, %w{config/database.yml config/initializers/secret_token.rb config/unicorn/test.rb config/initializers/errbit.rb config/resque.yml config/settings.yml}



before "bundler:install", "deploy:engines"

namespace :deploy do
  desc "Deploy engines"
  task :engines do
    on roles(:all) do
      ["diamond", "graphite"].each do |engine_name|
        within releases_path do
          if test("[ ! -d #{releases_path}/#{engine_name} ]")
            execute :git, "clone", fetch("#{engine_name}_url".to_sym), engine_name
          end
          # symlink needed for bundler when it will be run in scope of
          # current_path
          execute :ln, "-sf #{releases_path}/#{engine_name} ../"
          within engine_name do
            execute :git, "fetch origin", fetch("#{engine_name}_branch".to_sym)
            execute :git, "checkout FETCH_HEAD"
          end
        end
      end
    end
  end

  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end

  after :publishing, :restart

  desc 'Errbit notification about deploy'
  task :notify_errbit do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          airbrake_opts = "TO=#{fetch(:rails_env)} "
          airbrake_opts += "REVISION=#{fetch(:branch)} "
          airbrake_opts += "REPO=#{fetch(:repo_url)}"
          execute :bundle, :exec, :rake, 'airbrake:deploy', airbrake_opts
        end
      end
    end
  end

  after :publishing, :restart
  after :publishing, :notify_errbit
  after "deploy:restart", "resque:restart"

end
