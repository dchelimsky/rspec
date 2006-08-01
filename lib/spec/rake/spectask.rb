#!/usr/bin/env ruby

# Define a task library for running RSpec contexts.

require 'rake'
require 'rake/tasklib'

module Spec
module Rake

  # A task that runs a set of RSpec contexts.
  #
  # Example:
  #  
  #   Rake::SpecTask.new do |t|
  #     t.libs << "spec"
  #     t.spec_files = FileList['spec/**/*_spec.rb']
  #   end
  #
  class SpecTask < ::Rake::TaskLib

    # Name of spec task. (default is :spec)
    attr_accessor :name

    # List of directories to added to $LOAD_PATH before running the
    # specs. (default is 'lib')
    attr_accessor :libs

    # Options poassed to spec
    attr_accessor :spec_opts

    # Test options passed to the spec suite.  An explicit
    # SPECOPTS=opts on the command line will override this. (default
    # is NONE)
    attr_accessor :options

    # Request that the specs be run with the warning flag set.
    # E.g. warning=true implies "ruby -w" used to run the specs.
    attr_accessor :warning

    # Glob pattern to match spec files. (default is 'spec/spec*.rb')
    attr_accessor :pattern

    # Whether or not to use rcov (default is false)
    # See http://eigenclass.org/hiki.rb?rcov
    attr_accessor :rcov

    # Where output is written. Default is STDOUT.
    attr_accessor :out

    # Array of commandline options to pass to ruby (or rcov) when running specs.
    attr_accessor :ruby_opts

    # Whether or not to fail Rake when an error occurs (typically when specs fail).
    # Default is true
    attr_accessor :fail_on_error

    # A message to print to stdout when there are failures. Useful if +out+ is used.
    attr_accessor :failure_message

    # Explicitly define the list of spec files to be included in a
    # spec.  +list+ is expected to be an array of file names (a
    # FileList is acceptable).  If both +pattern+ and +spec_files+ are
    # used, then the list of spec files is the union of the two.
    def spec_files=(list)
      @spec_files = list
    end

    # Create a specing task.
    def initialize(name=:spec)
      @name = name
      @libs = ["lib"]
      @pattern = nil
      @options = nil
      @spec_files = nil
      @spec_opts = []
      @warning = false
      @rcov = false
      @ruby_opts = []
      @out = nil
      @fail_on_error = true
      yield self if block_given?
      @pattern = 'spec/**/*_spec.rb' if @pattern.nil? && @spec_files.nil?
      define
    end

    # Create the tasks defined by this task lib.
    def define
      lib_path = @libs.join(File::PATH_SEPARATOR)
      desc "Run specs" + (@name==:spec ? "" : " for #{@name}")
      task @name do
        specs = file_list
        raise "No spec files found." if specs.empty?
        
        spec = File.expand_path(File.dirname(__FILE__) + '/../../../bin/spec')
        file_prefix = @rcov ? " -- " : ""
        interpreter = @rcov ? "rcov" : "ruby"
        redirect = @out.nil? ? "" : " > #{@out}"

        @ruby_opts.unshift( "-I#{lib_path}" )
        @ruby_opts.unshift( "-w" ) if @warning
        @ruby_opts.unshift( '--exclude "lib\/spec\/.*"' ) if @rcov
        begin
          run interpreter, @ruby_opts.join(" ") +
            " \"#{spec}\" " +
            " #{@spec_opts.join(' ')} " +
            file_prefix +
            specs.collect { |fn| "\"#{fn}\"" }.join(' ') +
            redirect
          
          puts @failure_message if @failure_message && ($? != 0)
        rescue => e
          puts @failure_message if @failure_message
          raise e if @fail_on_error
        end
      end
      self
    end

    def file_list # :nodoc:
      if ENV['SPEC']
        FileList[ ENV['SPEC'] ]
      else
        result = []
        result += @spec_files.to_a if @spec_files
        result += FileList[ @pattern ].to_a if @pattern
        FileList[result]
      end
    end

    def run(interpreter, *args, &block)
      if Hash === args.last
        options = args.pop
      else
        options = {}
      end
      if args.length > 1 then
        sh(*([interpreter] + args + [options]), &block)
      else
        sh("#{interpreter} #{args}", options, &block)
      end
    end

  end
end
end

