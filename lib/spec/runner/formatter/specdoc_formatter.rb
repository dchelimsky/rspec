module Spec
  module Runner
    module Formatter
      class SpecdocFormatter < BaseTextFormatter      
        def add_context(name, first)
          @output.puts
          @output.puts name
          STDOUT.flush
        end
      
        def spec_failed(name, counter, failure)
          @output.print red("- #{name} (FAILED - #{counter})\n")
          STDOUT.flush
        end
      
        def spec_passed(name)
          @output.print green("- #{name}\n")
          STDOUT.flush
        end
      end
    end
  end
end