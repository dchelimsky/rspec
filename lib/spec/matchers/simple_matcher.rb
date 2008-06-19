module Spec
  module Matchers
    class SimpleMatcher
      attr_reader :description
      
      def initialize(description, &match_block)
        @description = description
        @match_block = match_block
        @messenger = Messenger.new
      end

      def matches?(actual)
        @actual = actual
        case @match_block.arity
        when 1
          return @match_block.call(@actual)
        when 2
          return @match_block.call(@actual, @messenger)
        end
      end

      def failure_message()
        return @messenger.failure_message(@description, @actual)
      end
        
      def negative_failure_message()
        return @messenger.negative_failure_message(@description, @actual)
      end
    end
    
    def simple_matcher(message, &match_block)
      SimpleMatcher.new(message, &match_block)
    end
    
    class Messenger
      def failure_message=(message)
        @custom_message = message
      end
      
      def negative_failure_message=(message)
        @custom_negative_message = message
      end
      
      def failure_message(description, actual)
        @custom_message ? @custom_message :
          %[expected #{description.inspect} but got #{actual.inspect}]
      end
      
      def negative_failure_message(description, actual)
        @custom_negative_message ? @custom_negative_message :
          %[expected not to get #{description.inspect}, but got #{actual.inspect}]
      end
    end
  end
end