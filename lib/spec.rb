require 'spec/matchers'
require 'spec/expectations'
require 'spec/example'
require 'spec/extensions'
require 'spec/runner'
require 'spec/adapters'
require 'spec/version'

if Object.const_defined?(:Test)
  require 'spec/interop/test'
end

module Spec
  class << self
    def run?
      @run || options.examples_run?
    end

    def run
      return true if run?
      result = options.run_examples
      @run = true
      result
    end
    attr_writer :run
    
    def exit?
      !Object.const_defined?(:Test) || Test::Unit.run?
    end

    def options
      $rspec_options ||= begin; \
        parser = ::Spec::Runner::OptionParser.new(STDERR, STDOUT); \
        parser.order!(ARGV); \
        $rspec_options = parser.options; \
      end
      $rspec_options
    end
    
    def init_options(options)
      $rspec_options = options if $rspec_options.nil?
    end
  end
end