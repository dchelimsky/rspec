module Spec
  module Example
    class Example
      PENDING_EXAMPLE_BLOCK = lambda {
        raise Spec::Example::ExamplePendingError.new("Not Yet Implemented")
      }
      attr_reader :from, :matcher_description
      
      def initialize(defined_description=nil, &implementation)
        @from = caller(0)[3]
        @implementation = implementation || PENDING_EXAMPLE_BLOCK
        @defined_description = defined_description
      end

      def run_in(context)
        return_value = nil
        @matcher_description = Matchers.capture_generated_description do
          return_value = context.instance_eval(&@implementation)
        end
        return_value
      end
      
      def description
        @defined_description || matcher_description || "NO NAME"
      end
      alias_method :to_s, :description
    end
  end
end
