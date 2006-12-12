module Spec
  module Expectations
    class MessageBuilder
      def build_message(actual, expectation, expected)
        message = "#{actual.inspect} #{expectation}"
        message << " " << expected.inspect
        message
      end
    end
  end
end