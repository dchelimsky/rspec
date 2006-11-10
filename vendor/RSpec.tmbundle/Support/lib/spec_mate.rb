require 'rubygems'
require 'spec'
require File.dirname(__FILE__) + '/text_mate_formatter'

class SpecMate
  def run_file(stdout, options={})
    options.merge!({:file => ENV['TM_FILENAME']})
    run(stdout, options)
  end

  def run_focussed(stdout, options={})
    options.merge!({:file => ENV['TM_FILENAME'], :line => ENV['TM_LINE_NUMBER']})
    run(stdout, options)
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

    ::Spec::Runner::CommandLine.run(argv, STDERR, stdout, false, true)
  end
end