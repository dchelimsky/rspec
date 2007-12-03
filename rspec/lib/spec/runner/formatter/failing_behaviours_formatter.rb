require 'spec/runner/formatter/base_text_formatter'

module Spec
  module Runner
    module Formatter
      class FailingBehavioursFormatter < BaseTextFormatter      
        def add_example_group(example_group_description)
          if example_group_description =~ /(.*) \(druby.*\)$/
            @example_group_description = $1
          else
            @example_group_description = example_group_description
          end
        end
      
        def example_failed(example, counter, failure)
          unless @example_group_description.nil?
            @output.puts @example_group_description
            @example_group_description = nil
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
