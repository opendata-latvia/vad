load 'deploy'
Dir['vendor/gems/*/recipes/*.rb','lib/*/recipes/*.rb'].each { |plugin| load(plugin) }
load 'config/deploy' # remove this line to skip loading any of the default tasks
load 'deploy/assets' # for asset precompilation task
