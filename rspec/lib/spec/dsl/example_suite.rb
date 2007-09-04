module Spec
  module DSL
    class ExampleSuite < ::Test::Unit::TestSuite
      attr_accessor :runner_options

      def initialize(name, behaviour)
        super name
        @behaviour = behaviour
        @runner_options = nil
      end

      def run(result, &progress_block)
        @behaviour.run(runner_options.reporter, runner_options.behaviour_runner_params)
      end
    end
  end
end