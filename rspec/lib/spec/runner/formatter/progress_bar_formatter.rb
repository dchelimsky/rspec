module Spec
  module Runner
    module Formatter
      class ProgressBarFormatter < BaseTextFormatter
        def add_behaviour(name)
          STDOUT.flush
        end
      
        def example_failed(name, counter, failure)
          @output.print failure.expectation_not_met? ? red('F') : magenta('F')
          STDOUT.flush
        end

        def example_passed(name)
          @output.print green('.')
          STDOUT.flush
        end
      
        def start_dump
          @output.puts
          STDOUT.flush
        end
      end
    end
  end
end