# encoding: utf-8

# 执行bundle install
require 'bundler/capistrano'

require "rvm/capistrano"
set :rvm_ruby_string, "ruby-2.0.0-p195"
set :rvm_type, :user

# set this to keep from missing any password prompts
default_run_options[:pty] = true

set :domain, "115.28.34.45"
#网站目录名称
set :application, "store"

set :scm, :git
set :repository,  "git@github.com:helloqidi/store.git"
set :branch, "master"
set :deploy_to, "/opt/project/#{application}"
set :deploy_via, :remote_cache

set :user, "helloqidi"
set :use_sudo, false

role :web, domain                         # Your HTTP server, Apache/etc
role :app, domain                          # This may be the same as your `Web` server
role :db,  domain, :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

namespace :deploy do
  desc "Start Application"
  task :start, :roles => :app do
    run "cd #{deploy_to}/current/; ./rainbows.sh start"
  end

  desc "Stop Application"
  task :stop, :roles => :app do
    run "cd #{deploy_to}/current/; ./rainbows.sh stop"
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "cd #{deploy_to}/current/; ./rainbows.sh restart"
  end
end
