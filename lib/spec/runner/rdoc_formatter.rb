module Spec
  module Runner
    class RdocFormatter
      def initialize(output)
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

      def dump_summary(duration, context_count, spec_count, failure_count)
      end
    end
  end
end