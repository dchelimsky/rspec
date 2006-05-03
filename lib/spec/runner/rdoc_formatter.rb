module Spec
  module Runner
    class RdocFormatter < BaseTextFormatter
      def initialize(output, dry_run=false)
        set_dry_run #regardless of submitted value
        @output = output
      end
  
      def add_context(name, first)
        @output << "# #{name}\n"
      end
  
      def spec_passed(name)
        @output << "# * #{name}\n"
      end

      def spec_failed(name, counter)
        @output << "# * #{name} [#{counter} - FAILED]\n"
      end
      
      def dump_failure(counter, failure)
      end
      
      def start_dump
      end
    end
  end
end