namespace :deploy do
  desc "reload the database with seed data"
  task :seed do
    run "cd #{current_path}; bundle exec rake db:seed RAILS_ENV=#{rails_env}"
  end

  after "deploy:setup", "deploy:seed" #load refinery initial pages and home page
end

