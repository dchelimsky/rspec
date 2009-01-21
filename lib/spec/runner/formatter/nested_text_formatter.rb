require 'spec/runner/formatter/base_text_formatter'

module Spec
  module Runner
    module Formatter
      class NestedTextFormatter < BaseTextFormatter
        def initialize(options, where)
          super
          @last_nested_example_groups = []
        end

        def add_example_group(example_group)
          super

          current_nested_example_groups = described_example_group_chain
          current_nested_example_groups.each_with_index do |nested_example_group, i|
            unless nested_example_group == @last_nested_example_groups[i]
              output.puts "#{'  ' * i}#{nested_example_group.description_args.join}"
            end
          end

          @last_nested_example_groups = described_example_group_chain
        end

        def example_failed(example, counter, failure)
          output.puts(red("#{current_indentation}#{example.description} (FAILED - #{counter})"))
          output.flush
        end

        def example_passed(example)
          message = "#{current_indentation}#{example.description}"
          output.puts green(message)
          output.flush
        end

        def example_pending(example, message, pending_caller)
          super
          output.puts yellow("#{current_indentation}#{example.description} (PENDING: #{message})")
          output.flush
        end

        def current_indentation
          '  ' * @last_nested_example_groups.length
        end

        def described_example_group_chain
          example_group.example_group_hierarchy.reject {|eg| eg.description_args.empty?}
        end
      end
    end
  end
end
