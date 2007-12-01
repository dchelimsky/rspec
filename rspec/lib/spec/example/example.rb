module Spec
  module Example
    class Example
      PENDING_EXAMPLE_BLOCK = lambda {
        raise Spec::Example::ExamplePendingError.new("Not Yet Implemented")
      }
      attr_reader :description
      attr_reader :from
      
      def initialize(description, &implementation)
        @from = caller(0)[3]
        @implementation = implementation || PENDING_EXAMPLE_BLOCK
        self.description = description
      end

      def description=(value)
        if value == :__generate_docstring
          @description = "NO NAME (Because of --dry-run)"
        else
          @description = value
        end
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
