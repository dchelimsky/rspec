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
      argv << '--spec'
      argv << spec_name(options[:file], options[:line].to_i)
    end
    if options[:dry_run]
      argv << '--dry-run'
    end

    ::Spec::Runner::CommandLine.run(argv, STDERR, stdout, false, true)
  end

  def spec_name(file, line)
    Scanner.new(File.read(file)).spec_at_line(line)
  end

  class Scanner
    def initialize(specification)
      @specification = specification
    end
    
    def spec_at_line(line_number)
      context = context_at_line(line_number)
      spec = find_in_scope(line_number, /^\s*specify\s+['|"](.*)['|"]/)
      if context && spec
        "#{context} #{spec}"
      elsif context
        context
      else
        nil
      end
    end
    
  protected

    def context_at_line(line_number)
      find_in_scope(line_number, /^\s*context\s+['|"](.*)['|"]/)
    end
    
    def find_in_scope(line_number, pattern)
      scope_at_line(line_number).each do |line| 
        return $1 if line =~ pattern
      end
      nil
    end

    def scope_at_line(line_number)
      lines = @specification.split("\n")
    	lines[0...line_number].reverse
    end
    
  end

end