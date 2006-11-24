# We have to make sure the rspec lib above gets loaded rather than the gem one (in case it's installed)
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/../../../../lib'))
require 'spec/rake/spectask'

task :pre_commit => [:pre_commit_1_1_6]

task :pre_commit_1_1_6 => [:set_rails_version_1_1_6, :pre_commit_tasks]

task :pre_commit_1_2_0 => [:set_rails_version_1_2_0, :pre_commit_tasks]

task :pre_commit_edge => [:set_rails_version_edge, :pre_commit_tasks]

task :pre_commit_tasks => [:clobber_sqlite, "db:migrate", :generate_rspec, "spec:all"]

task :set_rails_version_1_1_6 do
  ENV['RSPEC_RAILS_VERSION'] = '1.1.6'
end

task :set_rails_version_1_2_0 do
  ENV['RSPEC_RAILS_VERSION'] = '1.2.0'
end

task :set_rails_version_edge do
  ENV['RSPEC_RAILS_VERSION'] = 'edge'
end

task :clobber_sqlite do
  rm_rf 'db/*.db'
end

task :generate_rspec do
  result = `ruby script/generate rspec --force`
  raise "Failed to generate rspec environment:\n#{result}" if $? != 0 || result =~ /^Missing/
end
