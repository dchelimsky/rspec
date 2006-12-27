# We have to make sure the rspec lib above gets loaded rather than the gem one (in case it's installed)
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/../../../rspec/lib'))
require 'spec/rake/spectask'

namespace :rspec do
  desc "Run rspec_on_rails specs against all supported rails versions"
  task :pre_commit => "rspec:ensure_db_config" do
    ["rspec:pre_commit_1_1_6", "rspec:pre_commit_1_2_0", "rspec:pre_commit_edge"].each do |task|
      IO.popen("rake #{task} --verbose") do |io|
        io.each do |line|
          puts line
        end
      end
      raise "RSpec on Rails #{task} failed" if $? != 0
    end
  end

  desc "Run rspec_on_rails specs against rails 1.1.6"
  task :pre_commit_1_1_6 => "rspec:ensure_db_config" do
    ENV['RSPEC_RAILS_VERSION'] = '1.1.6'
    IO.popen("rake rspec:pre_commit_tasks --verbose") do |io|
      io.each do |line|
        puts line
      end
    end
    raise "RSpec failures" if $? != 0
  end

  desc "Run rspec_on_rails specs against rails 1.2.0"
  task :pre_commit_1_2_0 => "rspec:ensure_db_config" do
    ENV['RSPEC_RAILS_VERSION'] = '1.2.0'
    Rake::Task["rspec:pre_commit_tasks"].invoke rescue got_error = true
    raise "RSpec failures" if got_error
  end

  desc "Run rspec_on_rails specs against edge rails"
  task :pre_commit_edge => "rspec:ensure_db_config" do
    ENV['RSPEC_RAILS_VERSION'] = 'edge'
    Rake::Task["rspec:pre_commit_tasks"].invoke rescue got_error = true
    raise "RSpec failures" if got_error
  end

  task :pre_commit_tasks => ["rspec:clobber_sqlite_data", "db:migrate", "rspec:generate_rspec", "spec:all"]

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
  rake rspec:generate_mysql_config
  rake rspec:generate_sqlite3_config

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

  desc "configures config/database.yml for mysql"
  task :generate_mysql_config do
    copy 'config/database.mysql.yml', 'config/database.yml'
  end

  desc "configures config/database.yml for sqlite3"
  task :generate_sqlite3_config do
    copy 'config/database.sqlite3.yml', 'config/database.yml'
  end

  desc "deletes config/database.yml"
  task :clobber_db_config do
    rm 'config/database.yml'
  end

  desc "deletes sqlite databases"
  task :clobber_sqlite_data do
    rm_rf 'db/*.db'
  end
end