module Spec
  class TextRunner
 
    def initialize(args=[], appendable=$stdout)
      @verbose = true if args.include? "-v"
      @failures = Array.new
      @specification_count = 0
      @failure_count = 0
      @failed = false
      @output = appendable
      @context_count = 0
    end
    
    def run(what_to_run)
      run_context(what_to_run) if what_to_run.is_a? Context
    end
    
    def run_context(context)
      @context_count += 1
      start_run
      @output.puts context.name if @verbose
      context.run(self)
      end_run
    end

    def spec(spec)
      @failed = false
    end
  
    def pass(spec)
      @specification_count += 1
      @output << "." unless @verbose
      @output.puts "- #{spec.name}" if @verbose
    end

    def failure(spec, exception)
      @specification_count += 1
      @output << "F" unless @verbose unless @failed
      @output << "- #{spec.name} (FAILED)" if @verbose unless @failed
      @failure_count += 1 unless @failed
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
      lines = trace.
        reject {|line| line.include? "lib/spec"}.
        reject {|line | line.include? "./spec:"}.
        reject {|line | line.include? "__instance_exec_"}
      @output << lines.join("\n")
      @output << "\n\n"
    end
    
    def dump_duration(duration)
      @output << "Finished in " << duration.to_s << " seconds\n"
    end
    
    def dump_counts
      @output << "\n" << @context_count << " context#{ 's' if @context_count != 1 }, "
      @output << @specification_count.to_s << " specification#{ 's' if @specification_count != 1 }, "
      @output << @failure_count.to_s << " failure#{ 's' if @failure_count != 1 }\n"
    end
    
  end
end
