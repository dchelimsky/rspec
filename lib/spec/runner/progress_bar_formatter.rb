module Spec
  module Runner
    class ProgressBarFormatter < BaseTextFormatter
      def initialize(output, dry_run=false)
        set_dry_run if dry_run
        @output = output
      end
      
      def add_context(name, first)
        @output << "\n" if first
      end
      
      def spec_failed(name, counter)
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