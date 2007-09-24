module Spec
  module Runner
    class BehaviourRunner
      attr_reader :options
      def initialize(options)
        @behaviours = []
        @options = options
      end

      # Runs all behaviours and returns the number of failures.
      def run
        success = run_behaviours
        heckle if(success && @options.heckle_runner)
        success
      end

    protected

      def run_behaviours
        suite = ::Test::Unit::TestSuite.new("Rspec suite")
        @options.behaviours.each do |behaviour|
          suite << behaviour.suite
        end
        runner = ::Test::Unit::AutoRunner.new(true)
        runner.collector = proc {suite}
        ::Test::Unit::UI::TestRunnerMediator.current_behaviour_runner(self) do
          runner.run
        end
      end

      def heckle
        heckle_runner = @options.heckle_runner
        @options.heckle_runner = nil
        @options.behaviours = @behaviours
        behaviour_runner = self.class.new(@options)
        heckle_runner.heckle_with(behaviour_runner)
      end
    end
  end
end
