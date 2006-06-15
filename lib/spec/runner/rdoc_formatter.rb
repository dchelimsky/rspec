module Spec
  module Runner
    class RdocFormatter < BaseTextFormatter
      def add_context(name, first)
        @output << "# #{name}\n"
        @output.flush
      end
  
      def spec_passed(name)
        @output << "# * #{name}\n"
        @output.flush
      end

      def spec_failed(name, counter, failure)
        @output << "# * #{name} [#{counter} - FAILED]\n"
        @output.flush
      end
    end
  end
end