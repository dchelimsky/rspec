require 'rubygems'
require 'spec'
require 'stringio'

def set_env
  root = File.expand_path(File.dirname(__FILE__) + '/../../../rspec')
  ENV['TM_SPEC'] = "ruby -I\"#{root}/lib\" \"#{root}/bin/spec\""
  ENV['TM_RSPEC_HOME'] = "#{root}"
  ENV['TM_PROJECT_DIRECTORY'] = File.expand_path(File.dirname(__FILE__))
  ENV['TM_FILEPATH'] = nil
  ENV['TM_LINE_NUMBER'] = nil
end
