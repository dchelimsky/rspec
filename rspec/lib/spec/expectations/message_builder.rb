module Spec
  module Expectations
    #Gone at 0.9
    class MessageBuilder
      def build_message(actual, expectation, expected)
        "#{actual.inspect} #{expectation}#{expected.nil? ? "" : " #{expected.inspect}"}"
      end
    end
  end
end