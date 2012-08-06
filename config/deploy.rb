# Application
set :application, "smshare"
set :deploy_to, "/home/smshare/#{application}"

# Repository
set :scm, :git
set :repository,  "git@github.com:alianca/SMShare.git"

# Run Options
set :user, "smshare"
set :use_sudo, false
default_run_options[:pty] = true

# Servers
role :web, "kelthuzad.aliancaproject.com"
role :app, "kelthuzad.aliancaproject.com"
role :db,  "kelthuzad.aliancaproject.com", :primary => true

#	Passenger Recipes
namespace :deploy do
  task :start do; end
  task :stop do; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

# Bundler Recipes
namespace :bundler do
  task :create_symlink, :roles => :app do
    run "mkdir -p #{File.join(shared_path, 'bundle')}"
    run "ln -s #{File.join(shared_path, 'bundle')} #{File.join(current_release, '.bundle')}"
  end

  task :install, :roles => :app do
    bundler.create_symlink
    run "cd #{current_path} && bundle install --deployment"
  end
end
after "deploy:symlink", "bundler:install"

# MongoDB Recipes
namespace :deploy do
  task :migrate, :only => {:primary => true}, :roles => :db do; end # Ignore Migrations

  task :seed do
    run "cd #{current_path}; rake db:seed RAILS_ENV=production"
  end

  task :create_indexes do
    run "cd #{current_path}; rake db:create_indexes RAILS_ENV=production"
  end
end
after "deploy:symlink", "deploy:seed"
after "deploy:symlink", "deploy:create_indexes"

# NginX Recipes
# namespace :nginx do
#  desc "Change owner to www-data"
#  task :fix_owner, :roles => [ :app, :db, :web ] do
#          run "#{try_sudo} chown -R www-data:www-data #{deploy_to}"
#  end
#end
#after "deploy:setup", "nginx:fix_owner"
#after "deploy:symlink", "nginx:fix_owner"
