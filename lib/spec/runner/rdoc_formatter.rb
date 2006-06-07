module Spec
  module Runner
    class RdocFormatter < BaseTextFormatter
      def add_context(name, first)
        @output << "# #{name}\n"
      end
  
      def spec_passed(name)
        @output << "# * #{name}\n"
      end

      def spec_failed(name, counter)
        @output << "# * #{name} [#{counter} - FAILED]\n"
      end
    end
  end
end