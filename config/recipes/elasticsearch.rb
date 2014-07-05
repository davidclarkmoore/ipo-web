namespace :elasticsearch do
  desc "Install elasticsearch"
  task :install, roles: :web do
    run "#{sudo} apt-get update"
    run "#{sudo} apt-get install openjdk-7-jre-headless -y"
    run "cd /tmp"
    run "wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.1.1.deb"
    run "#{sudo} dpkg -i elasticsearch-1.1.1.deb"
  end
  after "deploy:install", "elasticsearch:install"

  %w[start stop restart].each do |command|
    desc "#{command} elasticsearch"
    task command, roles: :web do
      run "#{sudo} service elasticsearch #{command}"
    end
  end

  before "deploy:migrate", "elasticsearch:restart"
end