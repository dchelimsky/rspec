module Spec
  module Example
    class ExampleGroupProxy
      attr_reader :description
  
      def initialize(example_group)
        @description = example_group.description
      end
  
      def ==(other)
        other.description == description
      end
    end
  end
end

