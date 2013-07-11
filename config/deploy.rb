# encoding: utf-8

#一,初始步骤：
#1,本机配置,得到2个文件Capfile,deploy.rb.进行文件的修改配置.
#capify .
#
#2,在服务器上搭建好软件环境
#注:使用capistrano后不需要用gemset来管理项目的gem包了.
#
#3,nginx,rainbow中项目目录后增加current这一级
#
#4,本机执行:
#cap deploy:setup
#cap deploy(如果绑定了deploy:padrino_migrate_database需要暂时删除绑定,它本身会执行bundle:install,)
#
#5,初始化数据库
#cap deploy:padrino_create_database
#cap deploy:padrino_migrate_database
#
#6,ssh到服务器,执行db:seed
#padrino rake db:seed -e production
#
#二,平时操作步骤：
#1,cap deploy(需要绑定deploy:padrino_migrate_database,它本身会执行bundle:install,deploy:restart)
#
#2,查看,执行其他命令
#cap -vT
#...



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

desc "Padrino create database"
task :padrino_create_database, :roles => :app do
  run "cd #{deploy_to}/current/; bundle exec padrino rake ar:create -e production"
end

desc "Padrino migrate database"
task :padrino_migrate_database, :roles => :app do
  run "cd #{deploy_to}/current/; bundle exec padrino rake ar:migrate -e production"
end

#每次deploy后,执行migrate
after "deploy:symlink", "padrino_migrate_database"


desc "Store compress js css"
task :compress_js_css, :roles => :app do
  run "cd #{deploy_to}/current/; bundle exec padrino rake compress:compress_js_css -e production"
end


#曾经尝试的自动化执行db:seed命令,失败.最后指定ssh到服务器上手动执行.
#desc "Padrino create database seed"
#task :padrino_create_seed, :roles => :app do
#  run "cd #{deploy_to}/current/; bundle exec padrino rake db:seed -e production"
#end

#曾经尝试自动化解决 nokogiri 安装问题的方法,失败.最后只能在服务器上先NOKOGIRI_USE_SYSTEM_LIBRARIES=true gem install nokogiri安装好,再在Gemfile中给nokogiri指定path.
#before "deploy:finalize_update", "bundle_install_for_nokogiri"
#desc "Bundle install for nokogiri"
#task :bundle_install_for_nokogiri, :roles => :app do
#  run "cd #{release_path} && NOKOGIRI_USE_SYSTEM_LIBRARIES=true bundle install --gemfile #{release_path}/Gemfile --path #{shared_path}/bundle  --deployment --quiet --without development test"
#end
