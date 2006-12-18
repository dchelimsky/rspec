module Spec
  module Expectations
    class MessageBuilder
      def build_message(actual, expectation, expected)
        "#{actual.inspect} #{expectation} #{expected.inspect}"
      end
    end
  end
end