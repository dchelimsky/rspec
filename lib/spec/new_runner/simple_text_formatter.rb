class SimpleTextFormatter
  def initialize(output=STDOUT,verbose=false)
    @output = output
    @context_names = []
    @spec_names = []
    @failures = Hash.new
    @verbose = verbose
  end
  
  def start_time=(time)
    @start_time = time if @start_time.nil?
  end
  
  def end_time=(time)
    @end_time = time
  end
  
  def pass(context_name, spec_name)
    if @verbose
      dump_context_name(context_name)
      @output << "- #{spec_name}\n"
    else
      dump_initial_space
      @output << '.'
    end
    log_names(context_name, spec_name)
  end
  
  def fail(context_name, spec_name, error)
    @failures[spec_name] = error
    if @verbose
      dump_context_name(context_name)
      @output << "- #{spec_name} (FAILED - #{@failures.length})\n"
    else
      dump_initial_space
      @output << 'F'
    end
    log_names(context_name, spec_name)
  end
  
  def log_names(context_name, spec_name)
    @context_names << context_name
    @spec_names << spec_name
  end

  def dump_context_name(context_name)
    @output << "\n#{context_name}\n" unless @context_names.include? context_name
  end
  
  def dump_initial_space
    @output << "\n" if @context_names.empty?
  end
  
  def dump
    @output << "\n"
    dump_failures
    @output << "\n\n"
    @output << "Finished in " << (duration).to_s << " seconds\n\n"
    @output << "#{@context_names.length} context#{'s' unless @context_names.length == 1 }, "
    @output << "#{@spec_names.length} specification#{'s' unless @spec_names.length == 1 }, "
    @output << "#{@failures.length} failure#{'s' unless @failures.length == 1 }"
    @output << "\n"
  end

  def dump_failures
    @output << "\n"
    @failures.keys.inject(1) do |index, key|
      exception = @failures[key]
      @output << "\n\n" if index > 1
      @output << index.to_s << ") " 
      @output << "#{exception.message} (#{exception.class.name})\n"
      dump_backtrace(exception.backtrace)
      index + 1
    end
  end

  def dump_backtrace(trace)
    return if trace.nil?
    lines = trace.
      reject {|line| line.include? "lib/spec"}.
      reject {|line| line.include? "./spec:"}.
      reject {|line| line.include? "__instance_exec_"}.
      reject {|line| line =~ /bin\/\D+spec/}
    @output << lines.join("\n")
  end

  private
  
    def duration
      return @end_time - @start_time unless (@end_time.nil? or @start_time.nil?)
      return "0.0"
    end

end