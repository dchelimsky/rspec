# Don't change this file. Configuration is done in config/environment.rb and config/environments/*.rb
unless defined?(RAILS_ROOT)
  root_path = File.join(File.dirname(__FILE__), '..')

  unless RUBY_PLATFORM =~ /mswin32/
    require 'pathname'
    root_path = Pathname.new(root_path).cleanpath(true).to_s
  end

  RAILS_ROOT = root_path
end

if ENV['RSPEC_RAILS_VERSION'].nil?
  raise <<-EOM
The RSPEC_RAILS_VERSION environment variable is not set. 
Either set it in your shell to one of the dir names under vendor/rails,
or run Rake via the Multirails.rake script, which will iterate over
all available Rails versions:

  rake -f Multirails.rake pre_commit
EOM
end

puts "running against rails #{ENV['RSPEC_RAILS_VERSION']}"

unless defined?(Rails::Initializer)
  
  version_root = File.expand_path("#{RAILS_ROOT}/vendor/rails/#{ENV['RSPEC_RAILS_VERSION']}")
  if File.directory?(version_root)
    $LOAD_PATH.unshift "#{version_root}/actionpack/lib/"
    $LOAD_PATH.unshift "#{version_root}/actionmailer/lib/"
    $LOAD_PATH.unshift "#{version_root}/actionwebservice/lib/"
    $LOAD_PATH.unshift "#{version_root}/activerecord/lib/"
    $LOAD_PATH.unshift "#{version_root}/activeresource/lib/"
    $LOAD_PATH.unshift "#{version_root}/activesupport/lib/"
    $LOAD_PATH.unshift "#{version_root}/railties/lib/"
    require "#{version_root}/railties/lib/initializer"
  else
    raise "Attempting to run against rails #{version_root} but no such directory exists"
    exit
  end

  Rails::Initializer.run(:set_load_path) do |config|
    config.plugin_paths = File.expand_path("#{RAILS_ROOT}/../vendor/plugins")
  end
end