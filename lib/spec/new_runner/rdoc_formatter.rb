module Spec
  module Runner
    class RDocFormatter
      def initialize(output=STDOUT)
        @output = output
      end
  
      def add_context(name)
        @output << "# #{name}\n"
      end
  
      def add_spec(name)
        @output << "# * #{name}\n"
      end
    end
  end
end