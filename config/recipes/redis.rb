set_default(:redis_pid, "/var/run/redis/redis-server.pid")

namespace :redis do

  desc "Install the latest release of redis-server"
  task :install, roles: :app do
    add_apt_repo "chris-lea/redis-server"
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install redis-server"
  end
  after "deploy:install", "redis:install"
  
  
  %w[start stop restart].each do |command|
    desc "#{command} redis-sever"
    task command, roles: :app do
      run "#{sudo} service redis-server #{command}"
    end
  end

end