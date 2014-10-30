namespace :braintree do
  task :symlink_yml, roles: :app do
    run "ln -nfs #{shared_path}/config/braintree.yml #{release_path}/config/braintree.yml"
  end
  after "deploy:finalize_update", "braintree:symlink_yml"
end