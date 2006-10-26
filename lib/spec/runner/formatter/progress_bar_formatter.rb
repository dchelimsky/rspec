module Spec
  module Runner
    module Formatter
      class ProgressBarFormatter < BaseTextFormatter
        def add_context(name, first)
          @output.puts if first
          STDOUT.flush
        end
      
        def spec_failed(name, counter, failure)
          @output.print red('F')
          STDOUT.flush
        end

        def spec_passed(name)
          @output.print green('.')
          STDOUT.flush
        end
      
        def start_dump
          @output.puts
          STDOUT.flush
        end
      end
    end
  end
end