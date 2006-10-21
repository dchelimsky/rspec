module Spec
  module Runner
    module Formatter
      class SpecdocFormatter < BaseTextFormatter      
        def add_context(name, first)
          @output << "\n#{name}\n"
          @output.flush
        end
      
        def spec_failed(name, counter, failure)
          @output << red("- #{name} (FAILED - #{counter})\n")
          @output.flush
        end
      
        def spec_passed(name)
          @output << green("- #{name}\n")
          @output.flush
        end
      end
    end
  end
end