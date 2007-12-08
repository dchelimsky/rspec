require 'spec/runner/formatter/base_text_formatter'

module Spec
  module Runner
    module Formatter
      class FailingBehavioursFormatter < BaseTextFormatter
        def add_example_group(example_group)
          super
          @example_group_full_descriptions = example_group.full_description
        end

        def example_failed(example, counter, failure)
          if @example_group_full_descriptions
            full_descriptions = @example_group_full_descriptions.collect do |description|
              description =~ /(.*) \(druby.*\)$/ ? $1 : description
            end
            @output.puts full_descriptions.join(' : ')
            @output.flush
            @example_group_full_descriptions = nil
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
