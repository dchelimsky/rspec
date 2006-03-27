class SimpleTextReportBuilder
  def initialize(output=STDOUT)
    @output = output
    @specs = []
    @contexts = []
  end
  
  def add_context(context)
    @contexts << context
  end
  
  def add_spec(spec)
    @specs << spec
  end
  
  def dump
    @specs.each do |spec| 
      @output << "." unless spec.failed?
      @output << "F" if spec.failed?
    end
    @output << "\n\n"
    @output << dump_failures
    @output << "\n\n"
    @output << "Finished in " << (duration).to_s << " seconds\n\n"
    @output << "#{@contexts.length} context#{'s' unless @contexts.length == 1 }, "
    @output << "#{@specs.length} specification#{'s' unless @specs.length == 1 }, "
    @output.puts "#{failures.length} failure#{'s' unless failures.length == 1 }"
  end

  def dump_failures
    result = ""
    failures.inject(1) do |index, spec|
      result << "\n\n" if index > 1
      result << index.to_s << ")\n" 
      result << "#{spec.exception.message} (#{spec.exception.class.name})\n"
      result << dump_backtrace(spec.exception.backtrace)
      index + 1
    end
    result
  end

  def dump_backtrace(trace)
    result = ""
    lines = trace.
      reject {|line| line.include? "lib/spec"}.
      reject {|line | line.include? "./spec:"}.
      reject {|line | line.include? "__instance_exec_"}.
      reject {|line | line =~ /bin\/\D+spec/}
    result << lines.join("\n")
    result
  end
  
  def start_time=(time)
    @start_time = time if @start_time.nil?
  end
  
  def end_time=(time)
    @end_time = time
  end
  
  def duration
    return @end_time - @start_time unless (@end_time.nil? or @start_time.nil?)
    return "0.0"
  end
  
  def num_specs
    @specs.length
  end
  
  def failures
    @specs.reject {|spec| !spec.failed?}
  end
end