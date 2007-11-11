module Spec
  module Runner
    module Formatter
      class ProfileFormatter < ProgressBarFormatter
        
        def initialize(options, where)
          super
          @examples = []
        end
        
        def start(count)
          @output.puts "Profiling enabled."
        end
        
        def add_example_group(example)
          @behaviour = example
        end
        
        def example_started(example)
          @time = Time.now
        end
        
        def example_passed(example)
          super
          @examples << [@behaviour, example, Time.now - @time]
        end
        
        def start_dump
          super
          @output.puts "\n\nTop 10 slowest examples:\n"
          
          @examples = @examples.sort_by do |b, e, t|
            t
          end.reverse
          
          @examples[0..9].each do |e|
            @output.print red(sprintf("%.7f", e[2]))
            @output.puts " #{e[0]} #{e[1]}"
          end
          @output.flush
        end
      end
    end
  end
end
