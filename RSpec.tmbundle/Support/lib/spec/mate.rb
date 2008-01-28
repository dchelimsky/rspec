# This is based on Florian Weber's TDDMate
require 'rubygems'

rspec_rails_plugin = File.join(ENV['TM_PROJECT_DIRECTORY'],'vendor','plugins','rspec','lib')
if File.directory?(rspec_rails_plugin)
  $LOAD_PATH.unshift(rspec_rails_plugin)
elsif ENV['TM_RSPEC_HOME']
  rspec_lib = File.join(ENV['TM_RSPEC_HOME'], 'lib')
  unless File.directory?(rspec_lib)
    raise "TM_RSPEC_HOME points to a bad location: #{ENV['TM_RSPEC_HOME']}"
  end
  $LOAD_PATH.unshift(rspec_lib)
end
require 'spec'

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/..')
require 'spec/mate/runner'
require 'spec/mate/switch_command'
#require 'spec/mate/text_mate_formatter'
