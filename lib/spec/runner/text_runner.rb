module Spec
  class TextRunner
 
    def initialize(appendable = $stdout)
      @failures = Array.new
      @specification_count = 0
      @failed = false
      @output = appendable
    end

    def run(context_or_collection = Spec::Collector)
      start_run
      context_or_collection.collection.each {|context| context.run(self)}
      end_run
    end

    def spec(spec)
      @specification_count += 1
      @failed = false
    end
  
    def pass(spec)
      @output << "."
    end

    def failure(spec, exception)
      @output << "X" unless @failed
      @failed = true
      @failures << exception
    end
  
    def start_run
      @output << "\n"
      @start_time = Time.new
    end
  
    def end_run
      @end_time = Time.new
      @output << "\n\n"

      dump_failures
      
      dump_duration(@end_time - @start_time)
      
      dump_counts
    end    

    def dump_failures
      @failures.inject(1) do |index, exception|
        @output << index.to_s << ")\n" 
        @output << "#{exception.message} (#{exception.class.name})\n"
        dump_backtrace(exception.backtrace)
        index + 1
      end
    end

    def dump_backtrace(trace)
      lines = trace.reject {|line| line.include? "lib/spec"}.reject {|line | line.include? "./spec:"}
      @output << lines.join("\n")
      @output << "\n\n"
    end
    
    def dump_duration(duration)
      @output << "Finished in " << duration.to_s << " seconds\n"
    end
    
    def dump_counts
      @output << "\n" << @specification_count.to_s << " specifications, "
      @output.puts "#{@failures.size} failures"
    end
    
  end
end
