module Spec
  module Runner
    module Formatter
      class RdocFormatter < BaseTextFormatter
        def add_behaviour(name)
          @output.puts "# #{name}"
        end
  
        def example_passed(name)
          @output.puts "# * #{name}"
          @output.flush
        end

        def example_failed(name, counter, failure)
          @output.puts "# * #{name} [#{counter} - FAILED]"
        end
        
        def example_pending(name, message)
          @output.puts "# * #{name} [PENDING: #{message}]"
        end
      end
    end
  end
end
