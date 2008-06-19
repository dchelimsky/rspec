module Spec
  module Matchers
    class SimpleMatcher
      def initialize(description, &match_block)
        @messenger = Messenger.new(description)
        @match_block = match_block
      end

      def matches?(actual)
        @actual = actual
        @match_block.arity == 2 ?
          @match_block.call(@actual, @messenger) :
          @match_block.call(@actual)
      end

      def failure_message
        @messenger.failure_message(@actual)
      end
        
      def negative_failure_message
        @messenger.negative_failure_message(@actual)
      end
      
      def description
        @messenger.description
      end

      class Messenger
        attr_accessor :description
        attr_writer :failure_message, :negative_failure_message

        def initialize(description)
          @description = description
        end

        def failure_message(actual)
          @failure_message || %[expected #{@description.inspect} but got #{actual.inspect}]
        end

        def negative_failure_message(actual)
          @negative_failure_message || %[expected not to get #{@description.inspect}, but got #{actual.inspect}]
        end
      end
    end

    def simple_matcher(message, &match_block)
      SimpleMatcher.new(message, &match_block)
    end
  end
end