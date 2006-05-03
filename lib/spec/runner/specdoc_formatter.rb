module Spec
  module Runner
    class SpecdocFormatter < BaseTextFormatter
      def initialize(output, dry_run=false)
        set_dry_run if dry_run
        @output = output
      end
      
      def add_context(name, first)
        @output << "\n#{name}\n"
      end
      
      def spec_failed(name, counter)
        @output << "- #{name} (FAILED - #{counter})\n"
      end
      
      def spec_passed(name)
        @output << "- #{name}\n"
      end
      
      def start_dump
      end
    end
  end
end