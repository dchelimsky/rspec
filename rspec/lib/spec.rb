require 'spec/version'
require 'spec/matchers'
require 'spec/expectations'
require 'spec/example'
require 'spec/extensions'
require 'spec/runner'

if Object.const_defined?(:Test); \
  require 'spec/interop/test'; \
end

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
    
    def exit?; \
      !Object.const_defined?(:Test) || Test::Unit.run?; \
    end
  end
end

# TODO - checking for Story here is a hack to make sure that
# the example summary doesn't appear when running stories. What
# we should really be doing is making sure only the right formatters
# get loaded.
at_exit do \
  unless $! || Spec.const_defined?(:Story) || Spec.run?; \
    success = Spec.run; \
    exit success if Spec.exit?; \
  end \
end