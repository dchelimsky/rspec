module Spec
  module Runner
    class BehaviourRunner
      def initialize(options)
        @options = options
      end

      def run
        prepare
        success = true
        behaviours.each do |behaviour|

          success = success & behaviour.suite.run(nil)
        end
        return success
      ensure
        finish
      end

      protected
      def prepare
        reporter.start(number_of_examples)
        behaviours.reverse! if reverse
        set_sequence_numbers
      end

      def finish
        reporter.end
        reporter.dump
      end

      def reporter
        @options.reporter
      end

      def reverse
        @options.reverse
      end

      # Sets the #number on each ExampleDefinition
      def set_sequence_numbers
        number = 0
        behaviours.each do |behaviour|
          number = behaviour.set_sequence_numbers(number)
        end
      end      

      def behaviours
        @options.behaviours
      end

      def number_of_examples
        @options.number_of_examples
      end
    end
  end
end