dir = File.dirname(__FILE__)
$LOAD_PATH.unshift(File.expand_path("#{dir}/../pre_commit/lib"))
require "pre_commit"

desc "Run precommit for all installed versions of Rails"
task :pre_commit do
  PreCommit::RspecOnRails.new(self).pre_commit
end
