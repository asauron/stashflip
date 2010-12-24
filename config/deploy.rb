set :application, "stashflip"

default_run_options[:pty] = true
set :repository,  "git@173.255.219.178:stashflip.git"
set :scm, "git"
set :user, "root"  # The server's user for deploys
set :scm_passphrase, "workher1"  # The deploy user's password

set :branch, "master"
set :scm_verbose, true
set :deploy_via, :remote_cache


# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "173.255.219.178"                          # Your HTTP server, Apache/etc
role :app, "173.255.219.178"                          # This may be the same as your `Web` server
role :db,  "173.255.219.178", :primary => true # This is where Rails migrations will run
role :db,  "173.255.219.178"

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

 namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
 end