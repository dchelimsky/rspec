module Spec
  module Runner
    module Formatter
      class RdocFormatter < BaseTextFormatter
        def add_context(name, first)
          @output << "# #{name}\n"
          STDOUT.flush
        end
  
        def spec_passed(name)
          @output << "# * #{name}\n"
          STDOUT.flush
        end

        def spec_failed(name, counter, failure)
          @output << "# * #{name} [#{counter} - FAILED]\n"
          STDOUT.flush
        end
      end
    end
  end
end