require 'spec/runner/formatter/base_text_formatter'

module Spec
  module Runner
    module Formatter
      class NestedTextFormatter < BaseTextFormatter
        def add_example_group(example_group)
          super
          if example_group.description_args && !example_group.description_args.empty?
            output.puts "#{example_group_indentation(example_group)}#{example_group.description_args}"
            output.flush
          end
        end

        def example_failed(example, counter, failure)
          message = if failure.expectation_not_met?
            "#{example_group_indentation(example.class)}  #{example.description} (FAILED - #{counter})"
          else
            "#{example_group_indentation(example.class)}  #{example.description} (ERROR - #{counter})"
          end

          output.puts(failure.expectation_not_met? ? red(message) : magenta(message))
          output.flush
        end

        def example_passed(example)
          message = "#{example_group_indentation(example.class)}  #{example.description}"
          output.puts green(message)
          output.flush
        end

        def example_pending(example, message)
          super
          output.puts yellow("#{example_group_indentation(example.class)}  #{example.description} (PENDING: #{message})")
          output.flush
        end

        def example_group_indentation(example_group)
          example_group_chain = []
          example_group.send(:execute_in_class_hierarchy) do |parent_example_group|
            example_group_chain << parent_example_group if parent_example_group.description_args
          end
          '  ' * (example_group_chain - [example_group]).length
        end
      end
    end
  end
end
