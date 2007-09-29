require 'test/unit/ui/console/testrunner'

module Test
  module Unit
    module UI
      module Console
        class TestRunner
          # alias_method :orig_output, :output
          # def output(something, level=NORMAL)
          #   # DO NOTHING SO THAT ONLY RSPEC OUTPUT GETS SPIT OUT
          #   @io.puts(something) if (output?(level))
          #   @io.flush
          # end
        end
      end
    end
  end
end
