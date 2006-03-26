require 'socket' 
@socket
module Spec
  class GuiRunner
 
    def initialize(port)
      @failures = Array.new
      @specification_count = 0
      @failure_count = 0
      @failed = false
      @socket = TCPSocket.new("127.0.0.1", port)
			@socket << "connected\n"
    end

    def run(context_or_collection = Spec::Collector)
			specs = context_or_collection.collection
      start_run specs.size
      specs.each {|spec| spec.run(self)}
      end_run
			@socket.shutdown
    end

    def spec(spec)
      @failed = false
    end
  
    def pass(spec)
      @socket << "passed\n"
    end

    def failure(spec, exception)
			return if @failed
      @socket << "failed\n"
      @failed = true
      dump_failure(exception)
    end
  
    def start_run(number_of_specs)
      @socket << "start #{number_of_specs.to_i}\n"
    end
  
    def end_run
      @socket << "end\n"
    end    

    def dump_failure(exception)
   		@socket << "#{exception.message} (#{exception.class.name})\n"
      dump_backtrace(exception.backtrace)
			@socket << "!\n"
    end

    def dump_backtrace(trace)
    	lines = trace.reject {|line| line.include? "lib/spec"}.reject {|line | line.include? "./spec:"}
      @socket << lines.join("\n")
			@socket << "\n"
    end
    
  end
end
