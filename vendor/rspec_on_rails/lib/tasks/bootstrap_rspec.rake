# We have to make sure the rspec lib above gets loaded rather than the gem one (in case it's installed)
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/../../../../lib'))
require 'spec/rake/spectask'

task :pre_commit => [:clobber_sqlite, :migrate, :generate_rspec, "spec:all"]

task :clobber_sqlite do
  rm_rf 'db/*.db'
end

task :generate_rspec do
  `ruby script/generate rspec --force`
  raise "Failed to generate rspec environment" if $? != 0
end
