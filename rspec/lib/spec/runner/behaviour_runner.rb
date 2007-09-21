module Spec
  module Runner
    class BehaviourRunner
      def initialize(options)
        @behaviours = []
        @options = options
      end

      def add_behaviour(behaviour)
        if behaviour.shared?
          raise ArgumentError, "Cannot add Shared Example to the BehaviourRunner"
        end
        @behaviours << behaviour
        behaviour.rspec_options = @options
      end

      # Runs all behaviours and returns the number of failures.
      def run
        prepare
        failure_count = nil
        begin
          run_behaviours
        rescue Interrupt
        ensure
          failure_count = finish
        end

        heckle if(failure_count == 0 && @options.heckle_runner)
        failure_count
      end

      def prepare
        return if @already_prepared
        @already_prepared = true
        load_specs # This will populate @behaviours via callbacks to add_behaviour
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
        @behaviours.each do |behaviour|
          behaviour.rspec_options = @options
          suite = behaviour.suite
          suite.run(nil)
        end
        ::Test::Unit.run = true
      end

      # Sets the #number on each ExampleDefinition
      def set_sequence_numbers
        number = 0
        @behaviours.each do |behaviour|
          number = behaviour.set_sequence_numbers(number, @options.reverse)
        end
      end

      def load_specs
        @options.paths.each do |path|
          load path
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
