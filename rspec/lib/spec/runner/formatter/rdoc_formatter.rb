module Spec
  module Runner
    module Formatter
      class RdocFormatter < BaseTextFormatter
        def add_behaviour(name)
          @output.print "# #{name}\n"
          STDOUT.flush
        end
  
        def example_passed(name)
          @output.print "# * #{name}\n"
          STDOUT.flush
        end

        def example_failed(name, counter, failure)
          @output.print "# * #{name} [#{counter} - FAILED]\n"
          STDOUT.flush
        end
      end
    end
  end
end