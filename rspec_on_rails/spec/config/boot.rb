# Don't change this file. Configuration is done in config/environment.rb and config/environments/*.rb

unless defined?(RAILS_ROOT)
  root_path = File.join(File.dirname(__FILE__), '..')

  unless RUBY_PLATFORM =~ /mswin32/
    require 'pathname'
    root_path = Pathname.new(root_path).cleanpath(true).to_s
  end

  RAILS_ROOT = root_path
end

ENV['RSPEC_RAILS_VERSION'] ||= '1.1.6'

puts "running against rails #{ENV['RSPEC_RAILS_VERSION']}"

unless defined?(Rails::Initializer)
  
  version_root = File.expand_path("#{RAILS_ROOT}/vendor/rails/#{ENV['RSPEC_RAILS_VERSION']}")
  if File.directory?(version_root)
    $LOAD_PATH.unshift "#{version_root}/actionpack/lib/"
    $LOAD_PATH.unshift "#{version_root}/actionmailer/lib/"
    $LOAD_PATH.unshift "#{version_root}/actionwebservice/lib/"
    $LOAD_PATH.unshift "#{version_root}/activerecord/lib/"
    $LOAD_PATH.unshift "#{version_root}/activesupport/lib/"
    $LOAD_PATH.unshift "#{version_root}/railties/lib/"
    require "#{version_root}/railties/lib/initializer"
  else
    raise "Attempting to run against rails #{version_root} but no such directory exists"
    exit
  end
  
  Rails::Initializer.run(:set_load_path)
end