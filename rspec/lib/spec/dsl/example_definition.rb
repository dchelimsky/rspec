module Spec
  module DSL
    class ExampleDefinition
      # The global sequence number of this example
      attr_accessor :number, :description
      attr_reader :from, :example_block, :options

      def initialize(description, options={}, &example_block)
        @from = caller(0)[3]
        @options = options
        @example_block = example_block
        @description = description
      end

      def to_s
        description
      end

      def pending?
        @example_block.nil?
      end

      def should_raise
        @options[:should_raise]
      end

      def use_generated_description?
        @description == :__generate_description
      end
    end
  end
end
