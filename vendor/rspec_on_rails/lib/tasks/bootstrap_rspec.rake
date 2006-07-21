# This LOAD_PATH munging is not necessary if you have installed RSpec via Ruybygems.
# It's only done here in order to make sure we run against the RSpec SVN.
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../../../lib')
RSPEC_SVN = true

task :pre_commit => [:clobber_sqlite, :migrate, :generate_rspec, :spec]

task :clobber_sqlite do
  rm_rf 'db/*.db'
end

task :generate_rspec do
  `ruby script/generate rspec --force`
  raise "Failed to generate rspec environment" if $? != 0
end
