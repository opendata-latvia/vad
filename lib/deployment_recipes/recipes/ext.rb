namespace :deploy do

  desc "Restart rails server"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  desc "Start rails server"
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  desc "Stop rails server"
  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Create shared config directory"
  task :setup_config, :roles => :app do
    run "umask 02 && mkdir -p #{shared_path}/config"
  end

  desc "Copy shared config files to current config directory"
  task :copy_config, :roles => :app do
    run "[ -f #{shared_path}/config/database.yml ] && cp -f #{shared_path}/config/* #{release_path}/config/ || echo No shared config files"
  end

end
