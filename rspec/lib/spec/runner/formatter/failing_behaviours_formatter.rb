require 'spec/runner/formatter/base_text_formatter'

module Spec
  module Runner
    module Formatter
      class FailingBehavioursFormatter < BaseTextFormatter
        def add_example_group(example_group)
          super
          @example_group_description_parts = example_group.description_parts
        end

        def example_failed(example, counter, failure)
          if @example_group_description_parts
            description_partss = @example_group_description_parts.collect do |description|
              description =~ /(.*) \(druby.*\)$/ ? $1 : description
            end
            @output.puts description_partss.join(' ')
            @output.flush
            @example_group_description_parts = nil
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
