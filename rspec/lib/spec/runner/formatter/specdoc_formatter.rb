module Spec
  module Runner
    module Formatter
      class SpecdocFormatter < BaseTextFormatter      
        def add_behaviour(name)
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
          
          message += " (#{sprintf("%.3f", elapsed_time)} sec)" if profile? && !dry_run?
           
          @output.puts(failure.expectation_not_met? ? red(message) : magenta(message))
          @output.flush
        end
        
        def example_started(example)
          @started_time = Time.now
        end
      
        def example_passed(example)
          message = "- #{example.description}"
          message += " (#{sprintf("%.3f", elapsed_time)} sec)" if profile? && !dry_run?
          
          @output.puts green(message)
          @output.flush
        end
        
        def example_pending(behaviour_name, example_name, message)
          super
          @output.puts yellow("- #{example_name} (PENDING: #{message})")
          @output.flush
        end
        
      private

        def elapsed_time
          @started_time ? Time.now - @started_time : 0.0
        end
      end
    end
  end
end
