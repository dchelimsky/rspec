class SimpleTextFormatter
  def initialize(output=STDOUT)
    @output = output
    @context_names = []
    @spec_names = []
    @failures = Hash.new
  end
  
  def add_context_name(name)
    @context_names << name
  end
  
  def add_spec_name(name)
    @spec_names << name
  end
  
  def start_time=(time)
    @start_time = time if @start_time.nil?
  end
  
  def end_time=(time)
    @end_time = time
  end
  
  def pass(name)
    @output << '.'
  end
  
  def fail(name, error)
    @failures[name] = error
    @output << 'F'
  end

  def dump
    @output << "\n\n"
    dump_failures
    @output << "\n\n"
    @output << "Finished in " << (duration).to_s << " seconds\n\n"
    @output << "#{@context_names.length} context#{'s' unless @context_names.length == 1 }, "
    @output << "#{@spec_names.length} specification#{'s' unless @spec_names.length == 1 }, "
    @output << "#{@failures.length} failure#{'s' unless @failures.length == 1 }"
    @output << "\n"
  end

  def dump_failures
    @failures.keys.inject(1) do |index, key|
      exception = @failures[key]
      @output << "\n\n" if index > 1
      @output << index.to_s << ")\n" 
      @output << "#{exception.message} (#{exception.class.name})\n"
      dump_backtrace(exception.backtrace)
      index + 1
    end
  end

  def dump_backtrace(trace)
    return if trace.nil?
    lines = trace.
      reject {|line| line.include? "lib/spec"}.
      reject {|line | line.include? "./spec:"}.
      reject {|line | line.include? "__instance_exec_"}.
      reject {|line | line =~ /bin\/\D+spec/}
    @output << lines.join("\n")
  end

  private
  
    def duration
      return @end_time - @start_time unless (@end_time.nil? or @start_time.nil?)
      return "0.0"
    end

end