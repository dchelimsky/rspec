# We have to make sure the rspec lib above gets loaded rather than the gem one (in case it's installed)
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/../../../rspec/lib'))
require 'spec/rake/spectask'

desc "Run all specs against sample app and spec/rails (Rails 1.1.6 and 1.2.0 RC 1)"
task :pre_commit do
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
  raise "RSpec on Rails pre_commit failed" if $? != 0
end


desc "Run all specs against sample app and spec/rails (Rails 1.1.6, 1.2.0 RC 1 and edge)"
task :pre_commit_all do
  IO.popen("rake pre_commit --verbose") do |io|
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
task :pre_commit_1_1_6 do
  ENV['RSPEC_RAILS_VERSION'] = '1.1.6'
  Rake::Task["pre_commit_tasks"].invoke rescue got_error = true
  raise "RSpec failures" if got_error
end

desc "Run all specs against sample app and spec/rails (Rails 1.2.0 RC 1)"
task :pre_commit_1_2_0 do
  ENV['RSPEC_RAILS_VERSION'] = '1.2.0'
  Rake::Task["pre_commit_tasks"].invoke rescue got_error = true
  raise "RSpec failures" if got_error
end

task :pre_commit_edge do
  ENV['RSPEC_RAILS_VERSION'] = 'edge'
  Rake::Task["pre_commit_tasks"].invoke rescue got_error = true
  raise "RSpec failures" if got_error
end

task :pre_commit_tasks => [:ensure_db_config, :clobber_data, "db:migrate", :generate_rspec, "spec:all"]

task :generate_rspec do
  result = `ruby script/generate rspec --force`
  raise "Failed to generate rspec environment:\n#{result}" if $? != 0 || result =~ /^Missing/
end

task :ensure_db_config do
  config_path = 'config/database.yml'
  unless File.exists?(config_path)
    message = <<EOF
#####################################################
Could not find #{config_path}
You can get rake to generate this file for you using either of:
  rake generate_mysql_config
  rake generate_sqlite_config
  
If you use mysql, you'll need to create dev and test
databases and users for each. To do this, standing
in rspec_on_rails, log into mysql as root and then...
  mysql> source db/mysql_setup.sql;
  
There is also a teardown script that will remove
the databases and users:
  mysql> source db/mysql_teardown.sql;
#####################################################
EOF
    raise message
  end
end

task :generate_mysql_config do
  copy 'config/database.mysql.yml', 'config/database.yml'
end

task :generate_sqlite_config do
  copy 'config/database.sqlite.yml', 'config/database.yml'
end

task :clobber_db_config do
  rm 'config/database.yml'
end

task :clobber_data do
  rm_rf 'db/*.db'
end