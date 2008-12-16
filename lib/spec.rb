require 'spec/matchers'
require 'spec/expectations'
require 'spec/example'
require 'spec/runner'
require 'spec/version'
require 'spec/dsl'

module Spec
  def self.test_unit_defined?
    Object.const_defined?(:Test) && Test.const_defined?(:Unit) && Test::Unit.respond_to?(:run?)
  end

  def self.run?
    Runner.options.examples_run?
  end

  def self.run
    return true if run?
    Runner.options.run_examples
  end
  
  def self.exit?
    !test_unit_defined? || Test::Unit.run?
  end
end

if Spec::test_unit_defined?
  require 'spec/interop/test'
end
