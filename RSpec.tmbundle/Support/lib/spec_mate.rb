# This is based on Florian Weber's TDDMate
require 'rubygems'

rspec_rails_plugin = File.join(ENV['TM_PROJECT_DIRECTORY'],'vendor','plugins','rspec','lib')
if File.directory?(rspec_rails_plugin)
  $LOAD_PATH.unshift(rspec_rails_plugin)
elsif ENV['TM_RSPEC_HOME']
  rspec_lib = File.join(ENV['TM_RSPEC_HOME'], 'lib')
  $LOAD_PATH.unshift(rspec_lib)
  raise "TM_RSPEC_HOME points to a bad location: #{ENV['TM_RSPEC_HOME']}" unless File.directory?(rspec_lib)
end

require 'spec'
require File.dirname(__FILE__) + '/text_mate_formatter'

class SpecMate
  def run_files(stdout, options={})
    files = ENV['TM_SELECTED_FILES'].split(" ").map{|p| p[1..-2]}
    options.merge!({:files => files})
    run(stdout, options)
  end
  
  def run_file(stdout, options={})
    options.merge!({:files => [single_file]})
    run(stdout, options)
  end

  def run_focussed(stdout, options={})
    options.merge!({:files => [single_file], :line => ENV['TM_LINE_NUMBER']})
    run(stdout, options)
  end

  def single_file
    ENV['TM_FILEPATH'][ENV['TM_PROJECT_DIRECTORY'].length+1..-1]
  end
  
  def run(stdout, options)
    argv = options[:files].dup
    argv << '--format'
    argv << 'Spec::Runner::Formatter::TextMateFormatter'
    if options[:line]
      argv << '--line'
      argv << options[:line]
    end
    argv += ENV['TM_RSPEC_OPTS'].split(" ") if ENV['TM_RSPEC_OPTS']
    Dir.chdir(ENV['TM_PROJECT_DIRECTORY']) do
      ::Spec::Runner::CommandLine.run(argv, STDERR, stdout, false, true)
    end
  end
end