module Spec
  module Example
    class Example
      PENDING_EXAMPLE_BLOCK = lambda {
        raise Spec::Example::ExamplePendingError.new("Not Yet Implemented")
      }
      attr_accessor :description
      attr_reader :from, :implementation

      def initialize(description, &implementation)
        @from = caller(0)[3]
        @implementation = implementation
        @description = description
      end
      
      def to_s
        description
      end
    end
  end
end
