set :application, "amble"
set :scm, "git"
set :repository, "git@github.com:zol/amble.git"
set :branch, "production"

#keep a remote cache of the source code on the remote server, and
#deploy using that.  makes for very fast deploys
set :deploy_via, :remote_cache

set :deploy_to, "/data/#{application}/www"

set :user, "amble"
set :use_sudo, false

namespace :deploy do
  
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"    
  end
  
  desc "obfuscate javascript and css file"
  task :obfuscate, :roles => :web do
    run "cd #{release_path}; rake obfuscate:js; rake obfuscate:css"
  end

  desc "generate css from applicaiton sass file"
  task :generate_css, :roles => :web do
    run "cd #{release_path}; sass public/stylesheets/sass/application.sass > public/stylesheets/application.css"
    run "cd #{release_path}; sass public/stylesheets/sass/mobile.sass > public/stylesheets/mobile.css"
    run "cd #{release_path}; rm -Rf public/stylesheets/sass"
  end
end

after "deploy:update_code", "deploy:generate_css"
after "deploy:update_code", "deploy:obfuscate"

#checkout the code locally, then copy the checked out version to the server
EXCLUDE_FROM_DEPLOY = [
  ".git", 
	"resources"
	]
	
set :copy_exclude, EXCLUDE_FROM_DEPLOY
set :copy_compression, :bz2

role :app, "elara.icyte.com"
role :web, "elara.icyte.com"
role :db,  "elara.icyte.com", :primary => true