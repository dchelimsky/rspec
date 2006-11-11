require 'rubygems'
require 'spec'
require File.dirname(__FILE__) + '/text_mate_formatter'

class SpecMate
  def run_file(stdout, options={})
    options.merge!({:file => file_name})
    run(stdout, options)
  end

  def run_focussed(stdout, options={})
    options.merge!({:file => file_name, :line => ENV['TM_LINE_NUMBER']})
    run(stdout, options)
  end

  def file_name
    ENV['TM_FILEPATH'][ENV['TM_PROJECT_DIRECTORY'].length+1..-1]
  end
  
  def run(stdout, options)
    argv = [
      options[:file],
      '--format',
      'Spec::Runner::Formatter::TextMateFormatter'
    ]
    if options[:line]
      argv << '--line'
      argv << options[:line]
    end
    if options[:dry_run]
      argv << '--dry-run'
    end

    Dir.chdir(ENV['TM_PROJECT_DIRECTORY']) do
      ::Spec::Runner::CommandLine.run(argv, STDERR, stdout, false, true)
    end
  end
end