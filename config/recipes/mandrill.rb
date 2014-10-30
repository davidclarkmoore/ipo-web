set_default(:mandrill_api_key)    { Capistrano::CLI.ui.ask "Mandril API Key: " }
set_default(:mandrill_user_name)  { Capistrano::CLI.ui.ask "Mandrill Username: " }
set_default(:mandrill_password)   { Capistrano::CLI.password_prompt "Mandrill Password: " }
set_default(:mandrill_domain)     { Capistrano::CLI.ui.ask "Domain for emails: " }

namespace :mandrill do
  desc "Generate the mandrill.yml configuration file."
  task :setup_yml, roles: :app do
    run "mkdir -p #{shared_path}/config"
    template "mandrill.yml.erb", "#{shared_path}/config/mandrill.yml"
  end
  after "deploy:setup", "mandrill:setup_yml"

  task :symlink_yml, roles: :app do
    run "ln -nfs #{shared_path}/config/mandrill.yml #{release_path}/config/mandrill.yml"
  end
  after "deploy:finalize_update", "mandrill:symlink_yml"
end