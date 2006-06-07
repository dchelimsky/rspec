module Spec
  module Runner
    class ProgressBarFormatter < BaseTextFormatter
      def add_context(name, first)
        @output << "\n" if first
      end
      
      def spec_failed(name, counter, failure)
        @output << 'F'
      end
      
      def spec_passed(name)
        @output << '.'
      end
      
      def start_dump
        @output << "\n"
      end
    end
  end
end