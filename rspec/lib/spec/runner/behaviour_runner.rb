module Spec
  module Runner
    class BehaviourRunner
      attr_reader :options
      def initialize(options)
        @behaviours = []
        @options = options
      end

      def add_behaviour(behaviour)
        @behaviours << behaviour
        behaviour.rspec_options = @options
      end

      # Runs all behaviours and returns the number of failures.
      def run
        success = run_behaviours
        heckle if(success && @options.heckle_runner)
        success
      end

      def prepare
        @options.reporter.start(number_of_examples)
        @behaviours.reverse! if @options.reverse
        set_sequence_numbers
      end

      def finish
        @options.reporter.end
        @options.reporter.dump
      end

    protected

      def number_of_examples
        @behaviours.inject(0) {|sum, behaviour| sum + behaviour.number_of_examples}
      end

      def run_behaviours
        suite = ::Test::Unit::TestSuite.new("Rspec suite")
        @behaviours.each do |behaviour|
          behaviour.rspec_options = @options
          suite << behaviour.suite
        end
        runner = ::Test::Unit::AutoRunner.new(true)
        runner.collector = proc {suite}
        ::Test::Unit::UI::TestRunnerMediator.current_behaviour_runner(self) do
          runner.run
        end
      end

      # Sets the #number on each ExampleDefinition
      def set_sequence_numbers
        number = 0
        @behaviours.each do |behaviour|
          number = behaviour.set_sequence_numbers(number, @options.reverse)
        end
      end

      def heckle
        heckle_runner = @options.heckle_runner
        @options.heckle_runner = nil
        behaviour_runner = self.class.new(@options)
        behaviour_runner.instance_variable_set(:@behaviours, @behaviours)
        heckle_runner.heckle_with(behaviour_runner)
      end
    end
  end
end
