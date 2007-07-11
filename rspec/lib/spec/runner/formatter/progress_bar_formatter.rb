module Spec
  module Runner
    module Formatter
      class ProgressBarFormatter < BaseTextFormatter
        def add_behaviour(name)
        end
      
        def example_failed(name, counter, failure)
          @output.print colourise('F', failure)
          @output.flush
        end

        def example_passed(name)
          @output.print green('.')
          @output.flush
        end
      
        def example_pending(behaviour_name, example_name, message)
          super
          @output.print yellow('P')
          @output.flush
        end
        
        def start_dump
          @output.puts
          @output.flush
        end
      end
    end
  end
end
