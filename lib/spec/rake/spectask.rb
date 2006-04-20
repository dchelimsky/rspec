#!/usr/bin/env ruby

# Define a task library for running RSpec contexts.

require 'rake'
require 'rake/tasklib'
require File.dirname(__FILE__) + '/../../spec'

module Spec
module Rake

  # Create a task that runs a set of RSpec contexts.
  #
  # Example:
  #  
  #   Rake::SpecTask.new do |t|
  #     t.libs << "spec"
  #     t.spec_files = FileList['spec/**/*_spec.rb']
  #     t.verbose = true
  #   end
  #
  # If rake is invoked with a "SPEC=filename" command line option,
  # then the list of spec files will be overridden to include only the
  # filename specified on the command line.  This provides an easy way
  # to run just one spec.
  #
  # If rake is invoked with a "SPECOPTS=options" command line option,
  # then the given options are passed to the spec process after a
  # '--'.  This allows Test::Unit options to be passed to the spec
  # suite.
  #
  # Examples:
  #
  #   rake spec                           # run specs normally
  #   rake spec SPEC=just_one_file.rb     # run just one spec file.
  #   rake spec SPECOPTS="-v"             # run in verbose mode
  #   rake spec SPECOPTS="--runner=fox"   # use the fox spec runner
  #
  class SpecTask < ::Rake::TaskLib

    # Name of spec task. (default is :spec)
    attr_accessor :name

    # List of directories to added to $LOAD_PATH before running the
    # specs. (default is 'lib')
    attr_accessor :libs

    # True if verbose spec output desired. (default is false)
    attr_accessor :verbose

    # Test options passed to the spec suite.  An explicit
    # SPECOPTS=opts on the command line will override this. (default
    # is NONE)
    attr_accessor :options

    # Request that the specs be run with the warning flag set.
    # E.g. warning=true implies "ruby -w" used to run the specs.
    attr_accessor :warning

    # Glob pattern to match spec files. (default is 'spec/spec*.rb')
    attr_accessor :pattern

    # Array of commandline options to pass to ruby when running spec loader.
    attr_accessor :ruby_opts

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
      @verbose = false
      @warning = false
      @loader = :rake
      @ruby_opts = []
      yield self if block_given?
      @pattern = 'spec/**/*_spec.rb' if @pattern.nil? && @spec_files.nil?
      define
    end

    # Create the tasks defined by this task lib.
    def define
      lib_path = @libs.join(File::PATH_SEPARATOR)
      desc "Run specs" + (@name==:spec ? "" : " for #{@name}")
      task @name do
        run_code = File.dirname(__FILE__) + '/../../../bin/spec'

        RakeFileUtils.verbose(@verbose) do
          @ruby_opts.unshift( "-I#{lib_path}" )
          @ruby_opts.unshift( "-w" ) if @warning
          ruby @ruby_opts.join(" ") +
            " \"#{run_code}\" " +
            file_list.collect { |fn| "\"#{fn}\"" }.join(' ') +
            " #{option_list}"
        end
      end
      self
    end

    def option_list # :nodoc:
      ENV['SPECOPTS'] || @options || ""
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

    def find_file(fn) # :nodoc:
      $LOAD_PATH.each do |path|
      file_path = File.join(path, "#{fn}.rb")
        return file_path if File.exist? file_path
      end
      nil
    end
  end
end
end

