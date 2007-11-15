require 'test/unit'
require 'spec/version'
require 'spec/matchers'
require 'spec/expectations'
require 'spec/translator'
require 'spec/dsl'
require 'spec/extensions'
require 'spec/runner'
require 'spec/story'
require 'spec/test'
module Spec
  class << self
    def run?
      @run || rspec_options.examples_run?
    end

    def run; \
      return true if run?; \
      result = rspec_options.run_examples; \
      @run = true; \
      result; \
    end
    attr_writer :run
  end
end
