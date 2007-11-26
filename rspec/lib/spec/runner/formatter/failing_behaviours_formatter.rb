module Spec
  module Runner
    module Formatter
      class FailingBehavioursFormatter < BaseTextFormatter      
        def add_example_group(example_group_name)
          if example_group_name =~ /(.*) \(druby.*\)$/
            @example_group_name = $1
          else
            @example_group_name = example_group_name
          end
        end
      
        def example_failed(example, counter, failure)
          unless @example_group_name.nil?
            @output.puts @example_group_name
            @example_group_name = nil
            @output.flush
          end
        end

        def dump_failure(counter, failure)
        end

        def dump_summary(duration, example_count, failure_count, pending_count)
        end
      end
    end
  end
end
