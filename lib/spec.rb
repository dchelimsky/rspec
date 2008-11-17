require 'spec/matchers'
require 'spec/expectations'
require 'spec/example'
require 'spec/extensions'
require 'spec/runner'
require 'spec/adapters'
require 'spec/version'
require 'spec/dsl'

def test_unit_defined?
  Object.const_defined?(:Test) && Test.const_defined?(:Unit)
end

if test_unit_defined?
  require 'spec/interop/test'
end

module Spec
  class << self
    def run?
      Runner.options.examples_run?
    end

    def run
      return true if run?
      Runner.options.run_examples
    end
    
    def exit?
      !test_unit_defined? || Test::Unit.run?
    end

    def spec_command?
      $0.split('/').last == 'spec'
    end
  end
end
