set_default(:sf_api_client_id, "3MVG98XJQQAccJQfOIfYKJq5IT9AZVYCZj_xsH4X6lEDy5iaO66XDey0VlRVILVTw3egQ.TAfI0xIwBGZickm")
set_default(:sf_api_client_secret)  { Capistrano::CLI.ui.ask "SF API Client Secret: " }
set_default(:sf_api_username, "james.strong@etherpros.com")
set_default(:sf_api_password)       { Capistrano::CLI.password_prompt "SF API Password: " }
set_default(:sf_api_security_token) { Capistrano::CLI.ui.ask "SF API Security Token: " }



namespace :config_yml do
  desc "Generate the sf_api.yml configuration file."
  task :setup_sf_api, roles: :app do
    run "mkdir -p #{shared_path}/config"
    template "sf_api.yml.erb", "#{shared_path}/config/sf_api.yml"
  end
  after "deploy:setup", "config_yml:setup_sf_api"

  task :symlink_sf_api, roles: :app do
    run "ln -nfs #{shared_path}/config/sf_api.yml #{release_path}/config/sf_api.yml"
  end
  after "deploy:finalize_update", "config_yml:symlink_sf_api"

end