require 'spec/runner/formatter/base_text_formatter'

module Spec
  module Runner
    module Formatter
      class SpecdocFormatter < BaseTextFormatter      
        def add_example_group(example_group_description)
          @output.puts
          @output.puts example_group_description
          @output.flush
        end
      
        def example_failed(example, counter, failure)
          message = if failure.expectation_not_met?
            "- #{example} (FAILED - #{counter})"
          else
            "- #{example} (ERROR - #{counter})"
          end
          
          @output.puts(failure.expectation_not_met? ? red(message) : magenta(message))
          @output.flush
        end
        
        def example_passed(example)
          message = "- #{example}"
          @output.puts green(message)
          @output.flush
        end
        
        def example_pending(example_group_description, example_name, message)
          super
          @output.puts yellow("- #{example_name} (PENDING: #{message})")
          @output.flush
        end
      end
    end
  end
end
