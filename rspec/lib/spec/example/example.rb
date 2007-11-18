module Spec
  module DSL
    class Example
      # The global sequence number of this example
      attr_accessor :number, :description
      attr_reader :from, :example_block

      def initialize(description, &example_block)
        @from = caller(0)[3]
        @example_block = example_block || PENDING_EXAMPLE_BLOCK
        @description = description
      end
      
      def to_s
        description
      end

      private
      
        PENDING_EXAMPLE_BLOCK = lambda {
          raise Spec::DSL::ExamplePendingError.new("Not Yet Implemented")
        }
    end
  end
end
