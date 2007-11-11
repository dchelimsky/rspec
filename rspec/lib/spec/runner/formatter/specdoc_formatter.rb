module Spec
  module Runner
    module Formatter
      class SpecdocFormatter < BaseTextFormatter      
        def add_example_group(name)
          @output.puts
          @output.puts name
          @output.flush
        end
      
        def example_failed(example, counter, failure)
          message = if failure.expectation_not_met?
            "- #{example.description} (FAILED - #{counter})"
          else
            "- #{example.description} (ERROR - #{counter})"
          end
          
          @output.puts(failure.expectation_not_met? ? red(message) : magenta(message))
          @output.flush
        end
        
        def example_passed(example)
          message = "- #{example.description}"
          @output.puts green(message)
          @output.flush
        end
        
        def example_pending(behaviour_name, example_name, message)
          super
          @output.puts yellow("- #{example_name} (PENDING: #{message})")
          @output.flush
        end
      end
    end
  end
end
