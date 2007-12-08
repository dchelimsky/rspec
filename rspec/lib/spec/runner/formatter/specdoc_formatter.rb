require 'spec/runner/formatter/base_text_formatter'

module Spec
  module Runner
    module Formatter
      class SpecdocFormatter < BaseTextFormatter
        def add_example_group(example_group)
          super
          @level = 0
          full_description = example_group.full_description
          @output.puts
          full_description.each do |description|
            @output.puts "#{dashes}#{description}:"
            @level += 1 if @level < 2
          end
          @output.flush
        end
      
        def example_failed(example, counter, failure)
          message = if failure.expectation_not_met?
            "#{dashes}#{example} (FAILED - #{counter})"
          else
            "#{dashes}#{example} (ERROR - #{counter})"
          end
          
          @output.puts(failure.expectation_not_met? ? red(message) : magenta(message))
          @output.flush
        end
        
        def example_passed(example)
          message = "#{dashes}#{example}"
          @output.puts green(message)
          @output.flush
        end
        
        def example_pending(example_group_description, example_name, message)
          super
          @output.puts yellow("#{dashes}#{example_name} (PENDING: #{message})")
          @output.flush
        end

        def dashes
          if @level == 0
            ""
          else
            "#{'-'*@level} "
          end
        end
      end
    end
  end
end
