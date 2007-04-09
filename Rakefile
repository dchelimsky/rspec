dir = File.dirname(__FILE__)
$LOAD_PATH.unshift(File.expand_path("#{dir}/pre_commit/lib"))
require "pre_commit"

task :default => :pre_commit

desc "Runs pre_commit_core and pre_commit_rails"
task :pre_commit do
  pre_commit.pre_commit
end

desc "Makes sure the correct versions of gems are on the system"
task :check_for_gem_dependencies do
  pre_commit.check_for_gem_dependencies
end

desc "Runs pre_commit against rspec (core)"
task :pre_commit_core do
  pre_commit.pre_commit_core
end

desc "Runs pre_commit against example_rails_app (against all supported Rails versions)"
task :pre_commit_rails do
  pre_commit.pre_commit_rails
end

task :ok_to_commit do |t|
  pre_commit.ok_to_commit
end

desc "Touches files storing revisions so that svn will update $LastChangedRevision"
task :touch_revision_storing_files do
  pre_commit.touch_revision_storing_files
end

desc "Deletes generated documentation"
task :clobber do
  rm_rf 'doc/output'
end

desc "Installs dependencies for development environment"
task :install_dependencies do
  pre_commit.install_dependencies
end

desc "Updates dependencies for development environment"
task :update_dependencies do
  pre_commit.update_dependencies
end

def pre_commit
  PreCommit::Rspec.new(self)
end
