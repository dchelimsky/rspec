require 'spec/version'
require 'spec/matchers'
require 'spec/expectations'
require 'spec/translator'
require 'spec/dsl'
require 'spec/extensions'
require 'spec/runner'
require 'spec/story'

module Spec
  class << self
    def run?
      @run
    end
    attr_writer :run
  end
end
if Object.const_defined?(:Test)
  require 'spec/test'
else
  at_exit do
    unless $! || Spec.run?; exit rspec_options.run_examples; end
  end
end
