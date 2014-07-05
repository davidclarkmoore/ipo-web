require "bundler/capistrano"
require "capistrano/sidekiq"

load "config/recipes/base"
load "config/recipes/ssh"
load "config/recipes/nginx"
load "config/recipes/unicorn"
load "config/recipes/postgresql"
load "config/recipes/nodejs"
load "config/recipes/rbenv"
load "config/recipes/config_yml"
load "config/recipes/check"
load "config/recipes/redis"
load "config/recipes/elasticsearch"
load "config/recipes/imagemagick"
load "config/recipes/seed.rb" #refinery pages

server "162.209.8.93", :web, :app, :db, primary: true

set :user, "deployer"
set :application, "ipo-web"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:ipoconnection/#{application}.git"
set :branch, "master"

set :sidekiq_queue, ['projects','student_applications']

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases