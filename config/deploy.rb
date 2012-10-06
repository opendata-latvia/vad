default_run_options[:pty] = true  # Must be set for the password prompt from git to work

set :stages, %w( demo )
set :default_stage, "demo"
require 'capistrano/ext/multistage'
require "bundler/capistrano"
# set :whenever_command, "bundle exec whenever"
# require "whenever/capistrano"

set :user, "rails"
set :application, "vad"
set :keep_releases, 5
after "deploy", "deploy:cleanup"
set :use_sudo, false

set :scm , :git
set :repository, "git://github.com/opendata-latvia/vad.git"
set :repository_cache, "git_cache"
set :branch, "master"
set :deploy_via, :remote_cache

set(:deploy_to) { "/home/rails/#{application}/#{stage}" }
set(:rails_env) { stage }

set :default_environment, {
  'PATH' => '/usr/local/bin:/usr/bin:/bin',
  'GIT_SSL_NO_VERIFY' => '1'
}

namespace :deploy do

  after "deploy:setup",       "deploy:setup_config"
  after "deploy:update_code", "deploy:copy_config"

end
