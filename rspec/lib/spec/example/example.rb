module Spec
  module Example
    class Example
      PENDING_EXAMPLE_BLOCK = lambda {
        raise Spec::Example::ExamplePendingError.new("Not Yet Implemented")
      }
      attr_accessor :description
      attr_reader :from
      
      def initialize(description=nil, &implementation)
        @from = caller(0)[3]
        @implementation = implementation || PENDING_EXAMPLE_BLOCK
        self.description = description || "NO NAME"
      end

      def run_in(context)
        context.instance_eval(&@implementation)
      end
      
      def to_s
        description
      end
    end
  end
end
