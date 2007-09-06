module Spec
  module DSL
    class ExampleSuite < ::Test::Unit::TestSuite
      attr_accessor :rspec_options

      def initialize(name, behaviour)
        super name
        @behaviour = behaviour
        @rspec_options = nil
      end

      def run(result, &progress_block)
        @behaviour.run
      end

      def size
        @behaviour.number_of_examples
      end
    end
  end
end