require 'spec/runner/formatter/base_text_formatter'

module Spec
  module Runner
    module Formatter
      class FailingExampleGroupsFormatter < BaseTextFormatter
        def example_failed(example, counter, failure)
          if @example_group
            @output.puts ::Spec::Example::ExampleGroupMethods.
              description_text(*clean_druby_refs(@example_group.description_parts))

            @output.flush
            @example_group = nil
          end
        end
        
        def dump_failure(counter, failure)
        end

        def dump_summary(duration, example_count, failure_count, pending_count)
        end
        
      private
      
        def clean_druby_refs(description_parts)
          description_parts.collect do |description|
            description =~ /(.*) \(druby.*\)$/ ? $1 : description
          end
        end
      end
    end
  end
end
