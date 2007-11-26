module Spec
  module Runner
    module Formatter
      class FailingExamplesFormatter < BaseTextFormatter      
        def add_example_group(example_group_name)
          @example_group_name = example_group_name
        end
      
        def example_failed(example, counter, failure)
          @output.puts "#{@example_group_name} #{example.description}"
          @output.flush
        end

        def dump_failure(counter, failure)
        end

        def dump_summary(duration, example_count, failure_count, pending_count)
        end
      end
    end
  end
end
