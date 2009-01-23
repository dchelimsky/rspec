module Spec
  module Example
    class ExampleDescription
      attr_reader :description
      
      def initialize(example)
        @description = example.description
      end
      
      def ==(other)
        other.description == description
      end
    end
  end
end