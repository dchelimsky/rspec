# We have to make sure the rspec lib above gets loaded rather than the gem one (in case it's installed)
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/../../../../rspec/lib'))
require 'spec/rake/spectask'

desc "Run all specs against sample app and spec/rails (Rails 1.1.6, 1.2.0 RC 1 and edge)"
task :pre_commit_all do
  IO.popen("rake pre_commit_1_1_6 --verbose") do |io|
    io.each do |line|
      puts line
    end
  end
  IO.popen("rake pre_commit_1_2_0 --verbose") do |io|
    io.each do |line|
      puts line
    end
  end
  IO.popen("rake pre_commit_edge --verbose") do |io|
    io.each do |line|
      puts line
    end
  end
  raise "RSpec on Rails pre_commit_all failed" if $? != 0
end

desc "Run all specs against sample app and spec/rails (Rails 1.1.6)"
task :pre_commit => [:install_plugin, :set_rails_version_1_1_6, :pre_commit_tasks]

desc "Run all specs against sample app and spec/rails (Rails 1.2.0 RC 1)"
task :pre_commit_1_2_0 => [:set_rails_version_1_2_0, :pre_commit_tasks]

desc "Run all specs against sample app and spec/rails (Rails edge)"
task :pre_commit_edge => [:set_rails_version_edge, :pre_commit_tasks]

task :pre_commit_tasks => [:clobber_sqlite, "db:migrate", :generate_rspec, "spec:plugins"]

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

desc "installs the rspec_on_rails plugin in this project"
task :install_plugin do
  rm_rf 'vendor/plugins/rspec_on_rails'
  cp_r '../vendor/plugins/rspec_on_rails', 'vendor/plugins/rspec_on_rails'
end
