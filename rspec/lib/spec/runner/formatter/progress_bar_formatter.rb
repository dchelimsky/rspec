module Spec
  module Runner
    module Formatter
      class ProgressBarFormatter < BaseTextFormatter
        def add_behaviour(name)
        end
      
        def example_failed(name, counter, failure)
          @output.print failure.expectation_not_met? ? red('F') : magenta('F')
        end

        def example_passed(name)
          @output.print green('.')
        end
      
        def start_dump
          @output.puts
        end
      end
    end
  end
end