require 'spec/matchers'
require 'spec/expectations'
require 'spec/example'
require 'spec/extensions'
require 'spec/runner'
require 'spec/adapters'

if Object.const_defined?(:Test)
  require 'spec/interop/test'
end

module Spec
  class << self
    def run?
      @run || rspec_options.examples_run?
    end

    def run
      return true if run?
      result = rspec_options.run_examples
      @run = true
      result
    end
    attr_writer :run
    
    def exit?
      !Object.const_defined?(:Test) || Test::Unit.run?
    end
  end

  module VERSION
    unless defined? MAJOR
      MAJOR  = 1
      MINOR  = 1
      TINY   = 4
      RELEASE_CANDIDATE = nil

      BUILD_TIME_UTC = 20080628203842

      STRING = [MAJOR, MINOR, TINY].join('.')
      TAG = "REL_#{[MAJOR, MINOR, TINY, RELEASE_CANDIDATE].compact.join('_')}".upcase.gsub(/\.|-/, '_')
      FULL_VERSION = "#{[MAJOR, MINOR, TINY, RELEASE_CANDIDATE].compact.join('.')} (build #{BUILD_TIME_UTC})"

      NAME   = "RSpec"
      URL    = "http://rspec.rubyforge.org/"  

      SUMMARY = "#{NAME}-#{FULL_VERSION} - BDD for Ruby\n#{URL}"
    end
  end
end