load 'awesomeness'
%w(logs backup).each {|r| load "awesomeness/#{r}" }
# This defines a deployment "recipe" that you can feed to capistrano
# (http://manuals.rubyonrails.com/read/book/17). It allows you to automate
# (among other things) the deployment of your application.

# =============================================================================
# REQUIRED VARIABLES
# =============================================================================
# You must always specify the application and repository for every recipe. The
# repository must be the URL of the repository you want this recipe to
# correspond to. The deploy_to path must be the path on each machine that will
# form the root of the application path.

set :application, "yardvote.com"
set :repository, "git@github.com:collectiveidea/#{application}.git"

# =============================================================================
# ROLES
# =============================================================================
# You can define any number of roles, each of which contains any number of
# machines. Roles might include such things as :web, or :app, or :db, defining
# what the purpose of each machine is. You can also specify options that can
# be used to single out a specific subset of boxes in a particular role, like
# :primary => true.

role :web, "#{application}"
role :app, "#{application}"
role :db,  "#{application}", :primary => true

# =============================================================================
# OPTIONAL VARIABLES
# =============================================================================
set :deploy_to, "/home/voter/#{application}"
set :user, "voter"            # defaults to the currently logged in user
set :use_sudo, false
set :scm, :git
set :branch, 'master'
set :git_enable_submodules, true 
set :deploy_via, :remote_cache
set :ssh_options, {:forward_agent => true}
# set :scm, :darcs               # defaults to :subversion
# set :svn, "/path/to/svn"       # defaults to searching the PATH
# set :darcs, "/path/to/darcs"   # defaults to searching the PATH
# set :cvs, "/path/to/cvs"       # defaults to searching the PATH
# set :gateway, "gate.host.com"  # default to no gateway

# =============================================================================
# SSH OPTIONS
# =============================================================================
# ssh_options[:keys] = %w(/path/to/my/key /path/to/another/key)
# ssh_options[:port] = 25

# =============================================================================
# TASKS
# =============================================================================
# Define tasks that run on all (or only some) of the machines. You can specify
# a role (or set of roles) that each task should be executed on. You can also
# narrow the set of servers to a subset of a role by specifying options, which
# must match the options given for the servers to select (like :primary => true)

namespace :deploy do
  desc "mod_rails restart"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

desc "we need a database.  this helps with that."
task :after_update_code do
  run "mv #{release_path}/config/database.sample.yml #{release_path}/config/database.yml"
  run "ln -fs #{shared_path}/production.sqlite3 #{release_path}/db/production.sqlite3"
end
