require 'stringio'
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'spec'
require File.dirname(__FILE__) + '/../spec/spec/spec_classes'

module Spec
  module Matchers
    def fail
      raise_error(Spec::Expectations::ExpectationNotMetError)
    end

    def fail_with(message)
      raise_error(Spec::Expectations::ExpectationNotMetError, message)
    end

    class Pass
      def matches?(proc, &block)
        begin
          proc.call
          true
        rescue => @error
          false
        end
      end

      def failure_message
        @error.message + "\n" + @error.backtrace.join("\n")
      end
    end

    def pass
      Pass.new
    end
  end
end

# There are some examples that need to load the same files repeatedly.
# Requiring spec files instead of loading them (see http://rubyforge.org/tracker/?func=detail&atid=3152&aid=10814&group_id=797),
# caused these specs to fail.
#
# This shared behaviour solves that problem by redefining the behaviour of
# load_specs only for those examples.
unless defined?(RSPEC_EXAMPLES_THAT_LOAD_FILES)
  RSPEC_EXAMPLES_THAT_LOAD_FILES = describe "Examples that have to load files", :shared => true do
    before(:all) do
      Spec::Runner::BehaviourRunner.class_eval do
        alias_method :orig_load_specs, :load_specs
        def load_specs(paths)
          paths.each do |path|
            load path
          end
        end
      end
    end
  
    after(:all) do
      Spec::Runner::BehaviourRunner.class_eval do
        undef :load_specs
        alias_method :load_specs, :orig_load_specs
        undef :orig_load_specs
      end
    end
  end  
end