require 'stringio'
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'spec'
require File.dirname(__FILE__) + '/../spec/spec/spec_classes'

module Spec
  module Expectations
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
          rescue
            false
          end
        end

        def failure_message
          "Didn't pass"
        end
      end

      def pass
        Pass.new
      end
    end
  end
end
