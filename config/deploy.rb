set :application, "stashflip"
set :repository,  "gitosis@173.255.219.178:stashflip.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :user, "deploy"
set :scm_passphrase, "workher1"
set :branch, "master"
set :scm_verbose, true
set :deploy_via, :remote_cache
default_run_options[:pty] = true
set :rake, "/var/lib/gems/1.8/bin/rake"
set :runner, 'deploy'
set :admin_runner, 'deploy'

role :web, "173.255.219.178"                          # Your HTTP server, Apache/etc
role :app, "173.255.219.178"                          # This may be the same as your `Web` server
role :db,  "173.255.219.178", :primary => true # This is where Rails migrations will run
role :db,  "173.255.219.178"

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

 after "deploy:symlink", "deploy:update_crontab"
 
 namespace :deploy do
   task :start do ; end
   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch {File.join current_path,'tmp','restart.txt' }"
#end
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{release_path} && whenever --update-crontab #{application}"
  end
 end
 
 namespace :gems do
  desc "Install gems"
  task :install, :roles => :app do
    run "cd #{current_path} && #{sudo} rake RAILS_ENV=production gems:install"
  end
  end
  
  namespace :rake do  
  desc "Run a task on a remote server."  
  # run like: cap staging rake:invoke task=a_certain_task  
  task :invoke do  
    run("cd #{deploy_to}/current; /usr/bin/env rake #{ENV['task']} RAILS_ENV=#{rails_env}")  
  end  
end
