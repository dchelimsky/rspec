module Spec
  module DSL
    class ExampleSuite < ::Test::Unit::TestSuite
      attr_accessor :behaviour_runner_params

      def initialize(name, behaviour)
        super name
        @behaviour = behaviour
        @behaviour_runner_params = {}
      end

      def run(result, &progress_block)
        @behaviour.run(result, behaviour_runner_params)
      end
    end
  end
end