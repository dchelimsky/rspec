require 'spec/expectations/sugar'
require 'spec/expectations/errors'
require 'spec/expectations/extensions'
require 'spec/expectations/should'
require 'spec/expectations/matchers'
require 'spec/expectations/handler'

module Spec
  # See Spec::Expectations::ObjectExpectations for expectations that
  # are available on all objects.
  #
  # See Spec::Expectations::ProcExpectations for expectations that
  # are available on Proc objects.
  #
  # See Spec::Expectations::NumericExpectations for expectations that
  # are available on Numeric objects.
  module Expectations
    class << self
      attr_accessor :differ

      # raises a Spec::Expectations::ExpecationNotMetError with message
      #
      # When a differ has been assigned and fail_with is passed
      # <code>expected</code> and <code>target</code>, passes them
      # to the differ to append a diff message to the failure message.
      def fail_with(message, expected=nil, target=nil)
        if Array === message && message.length == 3
          message, expected, target = message[0], message[1], message[2]
        end
        unless (differ.nil? || expected.nil? || target.nil?)
          if expected.is_a?(String)
            message << "\nDiff:" << self.differ.diff_as_string(target.to_s, expected)
          elsif !target.is_a?(Proc)
            message << "\nDiff:" << self.differ.diff_as_object(target, expected)
          end
        end
        Kernel::raise(Spec::Expectations::ExpectationNotMetError.new(message))
      end
    end
  end
end