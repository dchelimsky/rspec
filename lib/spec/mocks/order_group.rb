module Spec
  module Mocks
    class OrderGroup
      def initialize
        @ordering = Array.new
      end
      
      def register(expectation)
        @ordering << expectation
      end
      
      def ready_for?(expectation)
        return @ordering.first == expectation
      end
      
      def consume(expectation)
        @ordering.shift
      end
    end
  end
end
