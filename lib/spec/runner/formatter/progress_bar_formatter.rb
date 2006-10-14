module Spec
  module Runner
    module Formatter
      class ProgressBarFormatter < BaseTextFormatter
        def add_context(name, first)
          @output << "\n" if first
          @output.flush
        end
      
        def spec_failed(name, counter, failure)
          @output << red('F')
          @output.flush
        end

        def spec_passed(name)
          @output << green('.')
          @output.flush
        end
      
        def start_dump
          @output << "\n"
          @output.flush
        end
      end
    end
  end
end