dir = File.dirname(__FILE__)
$LOAD_PATH.unshift(File.expand_path("#{dir}/../rspec/pre_commit/lib"))
require "pre_commit"

desc "Run precommit for all installed versions of Rails"
task :pre_commit do
  tasks.pre_commit
end

desc "Installs several versions of rails to run specs against"
task :install_dependencies do
  tasks.install_dependencies
end

desc "Updates the rails checkouts to run specs against"
task :update_dependencies do
  tasks.update_dependencies
end

def tasks
  PreCommit::RspecOnRails.new(self)
end